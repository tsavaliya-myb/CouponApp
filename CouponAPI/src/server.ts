import 'dotenv/config';
import { createApp } from './app';
import { env } from './config/env';
import { logger } from './config/logger';
import { prisma } from './config/db';
import { redis } from './config/redis';
import './jobs/export.worker';

import { scheduleExpiryReminders } from './jobs/expiryReminder.job';
import { scheduleDailyMotivation } from './jobs/dailyMotivation.job';

async function bootstrap() {
  // Verify DB connectivity before binding to port
  await prisma.$connect();
  logger.info('Database connected');

  // Boot scheduled background cron integrations
  await scheduleExpiryReminders();
  await scheduleDailyMotivation();

  const app = createApp();

  const server = app.listen(env.PORT, () => {
    logger.info(`🚀 Server running on port ${env.PORT} [${env.NODE_ENV}]`);
  });

  // Graceful shutdown
  const shutdown = async (signal: string) => {
    logger.info(`${signal} received — shutting down gracefully`);
    server.close(async () => {
      logger.info('HTTP server closed');
      await prisma.$disconnect();
      await redis.quit();
      logger.info('Database and Redis disconnected');
      process.exit(0);
    });
    // Force exit after 10 seconds
    setTimeout(() => {
      logger.error('Forced shutdown after timeout');
      process.exit(1);
    }, 10_000);
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT',  () => shutdown('SIGINT'));
  process.on('unhandledRejection', (reason) => {
    logger.error('Unhandled rejection', { reason });
    shutdown('unhandledRejection');
  });
  process.on('uncaughtException', (err: Error) => {
    logger.error('Uncaught exception', { error: err.message, stack: err.stack });
    shutdown('uncaughtException');
  });
}

bootstrap().catch((err) => {
  console.error('Bootstrap failed:', err);
  process.exit(1);
});
