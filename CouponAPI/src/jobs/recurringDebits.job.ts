import { Queue, Worker, Job } from 'bullmq';
import { redis } from '../config/redis';
import { logger } from '../config/logger';
import { prisma } from '../config/db';
import { env } from '../config/env';
import crypto from 'crypto';

const QUEUE_NAME = 'recurring-debits-queue';

export const recurringDebitsQueue = new Queue(QUEUE_NAME, { connection: redis as any });

export const recurringDebitsWorker = new Worker(
  QUEUE_NAME,
  async (job: Job) => {
    logger.info(`Processing recurringDebitsJob: ${job.id}`);
    const now = new Date();
    // We want to renew subscriptions that are expiring in the next 24 hours
    // Or exactly today, provided isAutopayEnabled is true
    const targetDate = new Date(now);
    targetDate.setDate(targetDate.getDate() + 1);

    try {
      const expiringSubs = await prisma.subscription.findMany({
        where: {
          status: 'ACTIVE',
          isAutopayEnabled: true,
          authPayUID: { not: null },
          endDate: { lte: targetDate },
        },
        include: { user: true },
      });

      if (expiringSubs.length === 0) {
        logger.info('recurringDebitsJob: No expiring subscriptions found for autopay.');
        return { attempted: 0, successful: 0, failed: 0 };
      }

      let successful = 0;
      let failed = 0;

      for (const sub of expiringSubs) {
        try {
          // Prepare si_transaction
          const txnid = `renew_${sub.userId.slice(0, 8)}_${Date.now()}`;
          const amount = "999.00"; // Should be fetched from settings ideally
          
          const var1Obj = {
            txnid,
            amount,
            productinfo: "CouponApp Annual Renewal",
            firstname: sub.user.name?.split(' ')[0] || 'Customer',
            email: sub.user.email || '',
            phone: (sub.user.phone || '').replace(/^\+91/, ''),
            authpayuid: sub.authPayUID
          };
          
          const var1 = JSON.stringify(var1Obj);
          const command = 'si_transaction';
          
          // Hash: key|command|var1|salt
          const hashStr = `${env.PAYU_KEY}|${command}|${var1}|${env.PAYU_SALT}`;
          const hash = crypto.createHash('sha512').update(hashStr).digest('hex');

          const payuUrl = env.PAYU_ENV === 'production' 
            ? 'https://info.payu.in/merchant/postservice.php'
            : 'https://test.payu.in/merchant/postservice.php';

          const bodyParams = new URLSearchParams({
            key: env.PAYU_KEY,
            command,
            var1,
            hash,
          });

          const response = await fetch(`${payuUrl}?form=2`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: bodyParams.toString(),
          });

          const data = await response.json() as any;
          
          // Handle response
          if (data.status === 1) {
            // Success
            logger.info('recurringDebitsJob: Renewal successful', { userId: sub.userId });
            successful++;
          } else {
            // Failure
            logger.warn('recurringDebitsJob: Renewal failed', { userId: sub.userId, error: data.error_code || data.msg });
            failed++;
            
            // Check for mandate revoked / user cancelled in UPI app (E001)
            // or equivalent error indicating mandate is no longer valid
            if (data.error_code === 'E001' || data.msg?.toLowerCase().includes('mandate')) {
              await prisma.subscription.update({
                where: { id: sub.id },
                data: {
                  isAutopayEnabled: false,
                  status: 'EXPIRED'
                }
              });
              logger.info('recurringDebitsJob: Mandate revoked by user. Autopay disabled and subscription expired.', { userId: sub.userId });
            }
          }
        } catch (err) {
          logger.error('recurringDebitsJob: Error processing subscription', { userId: sub.userId, err });
          failed++;
        }
      }

      return { attempted: expiringSubs.length, successful, failed };
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
