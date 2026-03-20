import { Queue, Worker, Job } from 'bullmq';
import { redis } from '../config/redis';
import { logger } from '../config/logger';
import { prisma } from '../config/db';
import { oneSignal } from '../modules/notifications/onesignal.service';
import { subDays, addDays, startOfDay, endOfDay } from 'date-fns';

const QUEUE_NAME = 'expiry-reminder-queue';

export const expiryReminderQueue = new Queue(QUEUE_NAME, { connection: redis as any });

export const expiryReminderWorker = new Worker(
  QUEUE_NAME,
  async (job: Job) => {
    logger.info(`Processing expiryReminderJob: ${job.id}`);
    const now = new Date();
    
    // Bounds for 7-days out
    const target7dStart = startOfDay(addDays(now, 7));
    const target7dEnd = endOfDay(addDays(now, 7));
    
    // Bounds for 2-days out
    const target2dStart = startOfDay(addDays(now, 2));
    const target2dEnd = endOfDay(addDays(now, 2));

    try {
      // Find subs expiring in exactly 7 days
      const subs7d = await prisma.subscription.findMany({
        where: { status: 'ACTIVE', endDate: { gte: target7dStart, lte: target7dEnd } },
        select: { userId: true },
      });

      // Find subs expiring in exactly 2 days
      const subs2d = await prisma.subscription.findMany({
        where: { status: 'ACTIVE', endDate: { gte: target2dStart, lte: target2dEnd } },
        select: { userId: true },
      });

      let dispatchedCount = 0;

      // Dispatch 7-day warnings
      for (const sub of subs7d) {
        await oneSignal.sendToUser(
          sub.userId,
          "Your Coupon Book is Expiring! ⚠️",
          "You only have 7 days left to use your remaining coupons. Don't miss out on savings!",
          "expiry_reminder_7d"
        );
        dispatchedCount++;
      }

      // Dispatch 2-day critically urgent warnings
      for (const sub of subs2d) {
        await oneSignal.sendToUser(
          sub.userId,
          "Urgent: Coupon Book expires in 48 hours! 🚨",
          "Hurry and redeem your unused coupons right now before they expire forever.",
          "expiry_reminder_2d"
        );
        dispatchedCount++;
      }

      logger.info(`Completed expiryReminderJob: Pushed ${dispatchedCount} expiry alerts`);
      return dispatchedCount;
    } catch (err) {
      logger.error('Failed processing expiryReminderJob', err);
      throw err;
    }
  },
  { connection: redis as any }
);

// Graceful unhandled tracking
expiryReminderWorker.on('failed', (job, err) => {
  logger.error(`ExpiryReminderJob ${job?.id} failed with error: ${err.message}`);
});

// Setup cron schedule (Runs daily at 9:00 AM)
export async function scheduleExpiryReminders() {
  await expiryReminderQueue.add('daily-expiry-check', {}, {
    repeat: { pattern: '0 9 * * *' } // 9:00 AM every single day
  });
  logger.info('Scheduled Cron: ExpiryReminderQueue linked for 09:00 AM daily.');
}
