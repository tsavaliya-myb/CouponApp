import { Queue, Worker, Job } from 'bullmq';
import { redis } from '../config/redis';
import { logger } from '../config/logger';
import { oneSignal } from '../modules/notifications/onesignal.service';

const QUEUE_NAME = 'daily-motivation-queue';

export const dailyMotivationQueue = new Queue(QUEUE_NAME, { connection: redis as any });

export const dailyMotivationWorker = new Worker(
  QUEUE_NAME,
  async (job: Job) => {
    logger.info(`Processing dailyMotivationJob: ${job.id}`);
    
    try {
      const templates = [
        { title: "Time to grab a bite? 🍕💆", body: "Check out your active coupons and grab a brand new deal available exclusively for you right now!" },
        { title: "Treat Yourself Today! ✨", body: "You've got unused discounts waiting. Why not save some money on a great experience today?" },
        { title: "Craving something delicious? 🍽️", body: "Open the app to find the best nearby restaurants offering huge discounts right now!" },
        { title: "Don't leave money on the table! 💸", body: "Your active coupons are essentially free money. Find a deal to use today and save big." },
        { title: "Relax & Unwind 🧖‍♀️", body: "Take a break today! Check your coupon book for amazing spa and salon deals nearby." }
      ];
      
      const idx = Math.floor(Math.random() * templates.length);
      const msg = templates[idx];

      // Fire generic motivation broadcast to all globally tracked Active Subscribers
      await oneSignal.sendGlobally(
        msg.title,
        msg.body,
        'daily_motivation_job'
      );
      
      logger.info(`Completed dailyMotivationJob successfully!`);
      return true;
    } catch (err) {
      logger.error('Failed processing dailyMotivationJob', err);
      throw err;
    }
  },
  { connection: redis as any }
);

dailyMotivationWorker.on('failed', (job, err) => {
  logger.error(`DailyMotivationJob ${job?.id} failed with error: ${err.message}`);
});

// Setup cron schedule (Runs daily at 10:00 AM)
export async function scheduleDailyMotivation() {
  await dailyMotivationQueue.add('daily-motivation-push', {}, {
    repeat: { pattern: '0 10 * * *' } // 10:00 AM every single day
  });
  logger.info('Scheduled Cron: DailyMotivationQueue linked for 10:00 AM daily.');
}
