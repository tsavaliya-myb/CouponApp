import { Queue, Worker, Job } from 'bullmq';
import { redis } from '../config/redis';
import { logger } from '../config/logger';
import { prisma } from '../config/db';

const QUEUE_NAME = 'subscription-expiry-queue';

export const subscriptionExpiryQueue = new Queue(QUEUE_NAME, { connection: redis as any });

export const subscriptionExpiryWorker = new Worker(
  QUEUE_NAME,
  async (job: Job) => {
    logger.info(`Processing subscriptionExpiryJob: ${job.id}`);
    const now = new Date();

    try {
      // ── Step 1: Find all subscriptions that have passed their endDate ──────
      const expiredSubs = await prisma.subscription.findMany({
        where: {
          status: 'ACTIVE',
          endDate: { lt: now },
        },
        select: {
          id: true,
          userId: true,
          couponBook: { select: { id: true } },
        },
      });

      if (expiredSubs.length === 0) {
        logger.info('subscriptionExpiryJob: No expired subscriptions found. Nothing to do.');
        return { expiredSubscriptions: 0, expiredUserCoupons: 0 };
      }

      const subscriptionIds = expiredSubs.map((s) => s.id);
      const couponBookIds = expiredSubs
        .map((s) => s.couponBook?.id)
        .filter((id): id is string => !!id);

      // ── Step 2: Bulk-expire in a single atomic transaction ─────────────────
      const [updatedSubs, updatedCoupons] = await prisma.$transaction([

        // Flip subscriptions → EXPIRED
        prisma.subscription.updateMany({
          where: { id: { in: subscriptionIds } },
          data: { status: 'EXPIRED' },
        }),

        // Cascade: flip all ACTIVE UserCoupons in those coupon books → EXPIRED
        // (USED coupons are already consumed — skip them)
        prisma.userCoupon.updateMany({
          where: {
            couponBookId: { in: couponBookIds },
            status: 'ACTIVE',
          },
          data: { status: 'EXPIRED' },
        }),

      ]);

      logger.info(
        `subscriptionExpiryJob completed: ${updatedSubs.count} subscriptions expired, ` +
        `${updatedCoupons.count} user coupons marked EXPIRED.`
      );

      return {
        expiredSubscriptions: updatedSubs.count,
        expiredUserCoupons: updatedCoupons.count,
      };
    } catch (err) {
      logger.error('subscriptionExpiryJob failed', err);
      throw err;
    }
  },
  { connection: redis as any },
);

subscriptionExpiryWorker.on('failed', (job, err) => {
  logger.error(`subscriptionExpiryJob ${job?.id} failed: ${err.message}`);
});

// Setup cron schedule — runs every night at 00:00 (midnight)
export async function scheduleSubscriptionExpiry() {
  await subscriptionExpiryQueue.add('nightly-subscription-expiry', {}, {
    repeat: { pattern: '0 0 * * *' }, // midnight every day
  });
  logger.info('Scheduled Cron: subscriptionExpiryQueue linked for 00:00 midnight daily.');
}
