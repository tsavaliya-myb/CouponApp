import { Queue } from 'bullmq';
import { redis } from '../config/redis';

// Note: BullMQ traditionally prefers a fresh connection, but reusing the ioredis instance 
// often works for the client Queue adding jobs. 
export const exportQueue = new Queue('export-settlements', {
  connection: redis as any,
});
