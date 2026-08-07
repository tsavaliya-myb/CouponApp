import { Queue, Worker, Job } from 'bullmq';
import { redis } from '../config/redis';
import { logger } from '../config/logger';
import { prisma } from '../config/db';
import { razorpay, toPaise } from '../config/razorpay';

const QUEUE_NAME = 'recurring-debits-queue';

export const recurringDebitsQueue = new Queue(QUEUE_NAME, { connection: redis as any });

export const recurringDebitsWorker = new Worker(
  QUEUE_NAME,
  async (job: Job) => {
    logger.info(`Processing recurringDebitsJob: ${job.id}`);
    const now = new Date();

    // UPI subsequent debits take 24–36h to settle, and must not be created on
    // the last day of the mandate cycle. Firing 48–72h ahead of endDate gives
    // the debit room to land before the book actually expires.
    const windowStart = new Date(now.getTime() + 48 * 3600 * 1000);
    const windowEnd   = new Date(now.getTime() + 72 * 3600 * 1000);

    try {
      const priceSetting = await prisma.appSetting.findUnique({
        where: { key: 'subscription_price' },
      });
      const rupees = priceSetting ? parseFloat(priceSetting.value) : 999;
      const amountPaise = toPaise(rupees);

      const expiringSubs = await prisma.subscription.findMany({
        where: {
          status:              'ACTIVE',
          isAutopayEnabled:    true,
          razorpayTokenId:     { not: null },
          renewalFailureCount: { lt: 3 },
          endDate:             { gte: windowStart, lt: windowEnd },
        },
        include: { user: true },
      });

      if (expiringSubs.length === 0) {
        logger.info('recurringDebitsJob: No expiring subscriptions found for autopay.');
        return { attempted: 0, created: 0, skipped: 0, failed: 0 };
      }

      let created = 0;
      let skipped = 0;
      let failed  = 0;

      for (const sub of expiringSubs) {
        try {
          if (!sub.user.razorpayCustomerId || !sub.razorpayTokenId) {
            logger.warn('recurringDebitsJob: missing razorpayCustomerId/razorpayTokenId — skipping', { userId: sub.userId });
            skipped++;
            continue;
          }

          // One in-flight renewal per subscription — never create a second
          // debit before the previous one's outcome (payment.captured/failed)
          // has landed via webhook.
          const inFlight = await prisma.paymentAttempt.findFirst({
            where: { subscriptionId: sub.id, kind: 'RENEWAL', status: 'PENDING' },
          });
          if (inFlight) {
            logger.info('recurringDebitsJob: renewal already in flight — skipping', { userId: sub.userId, subscriptionId: sub.id });
            skipped++;
            continue;
          }

          const contact = (sub.user.phone || '').replace(/^\+91/, '');
          const order = await razorpay.orders.create({
            amount:   amountPaise,
            currency: 'INR',
            receipt:  `rnw_${sub.userId.slice(0, 8)}_${Date.now()}`.slice(0, 40),
            notes:    { userId: sub.userId, kind: 'RENEWAL', subscriptionId: sub.id },
          });

          await prisma.paymentAttempt.create({
            data: {
              userId:          sub.userId,
              subscriptionId:  sub.id,
              razorpayOrderId: order.id,
              amount:          rupees.toFixed(2) as any,
              kind:            'RENEWAL',
              status:          'PENDING',
            },
          });

          await razorpay.payments.createRecurringPayment({
            email:       sub.user.email || '',
            contact,
            amount:      amountPaise,
            currency:    'INR',
            order_id:    order.id,
            customer_id: sub.user.razorpayCustomerId,
            token:       sub.razorpayTokenId,
            recurring:   true,
            description: 'CouponApp Coupon Book Renewal',
            notes:       { userId: sub.userId, kind: 'RENEWAL', subscriptionId: sub.id },
          });

          logger.info('recurringDebitsJob: renewal debit requested', { userId: sub.userId, orderId: order.id });
          created++;
          // Final outcome (extend endDate / bump renewalFailureCount) is
          // handled by the payment.captured / payment.failed webhook — not here.
        } catch (err) {
          logger.error('recurringDebitsJob: error processing subscription', { userId: sub.userId, err });
          failed++;
        }
      }

      return { attempted: expiringSubs.length, created, skipped, failed };
    } catch (err) {
      logger.error('recurringDebitsJob failed', err);
      throw err;
    }
  },
  { connection: redis as any },
);

recurringDebitsWorker.on('failed', (job, err) => {
  logger.error(`recurringDebitsJob ${job?.id} failed: ${err.message}`);
});

export async function scheduleRecurringDebits() {
  await recurringDebitsQueue.add('daily-recurring-debits', {}, {
    repeat: { pattern: '0 9 * * *' }, // 9 AM daily
  });
  logger.info('Scheduled Cron: recurringDebitsQueue linked for 09:00 AM daily.');
}
