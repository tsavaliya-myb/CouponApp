import { PrismaClient } from '@prisma/client';
import { logger } from './logger';

const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient };

export const prisma: PrismaClient =
  globalForPrisma.prisma ??
  new PrismaClient({
    log: [
      { emit: 'event', level: 'query' },
      { emit: 'event', level: 'error' },
      { emit: 'event', level: 'warn' },
    ],
  });

// Log slow queries in development
if (process.env.NODE_ENV === 'development') {
  prisma.$on('query' as never, (e: any) => {
    if (e.duration > 200) {
      logger.debug(`Slow query (${e.duration}ms): ${e.query}`);
    }
  });
}

prisma.$on('error' as never, (e: any) => {
  logger.error('Prisma error', e);
});

// Reuse client across hot-reloads in development
if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}
