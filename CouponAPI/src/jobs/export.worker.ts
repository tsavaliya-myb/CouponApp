import { Worker, Job } from 'bullmq';
import { redis } from '../config/redis';
import { createObjectCsvWriter } from 'csv-writer';
import path from 'path';
import os from 'os';
import { prisma } from '../config/db';

export const exportWorker = new Worker(
  'export-settlements',
  async (job: Job) => {
    const { adminId } = job.data;
    
    // 1. Fetch data
    const settlements = await prisma.settlement.findMany({
      include: { seller: { select: { businessName: true, email: true } } },
      orderBy: { weekStart: 'desc' },
    });

    // 2. Format
    const records = settlements.map((s) => ({
      id: s.id,
      sellerName: s.seller.businessName,
      weekStart: s.weekStart.toISOString().split('T')[0],
      commissionTotal: s.commissionTotal,
      commissionStatus: s.commissionStatus,
      coinCompTotal: s.coinCompensationTotal,
      coinCompStatus: s.coinCompStatus,
    }));

    // 3. Write CSV
    const fileName = `settlements_export_${job.id}.csv`;
    const filePath = path.join(os.tmpdir(), fileName);
    
    const csvWriter = createObjectCsvWriter({
      path: filePath,
      header: [
        { id: 'id', title: 'SETTLEMENT ID' },
        { id: 'sellerName', title: 'SELLER' },
        { id: 'weekStart', title: 'WEEK START' },
        { id: 'commissionTotal', title: 'COMMISSION OWED' },
        { id: 'commissionStatus', title: 'COMMISSION STATUS' },
        { id: 'coinCompTotal', title: 'COIN COMP OWED' },
        { id: 'coinCompStatus', title: 'COIN COMP STATUS' },
      ],
    });

    await csvWriter.writeRecords(records);

    console.log(`[Worker] Export finished: ${filePath}`);

    return { filePath, downloadUrl: `/api/v1/downloads/${fileName}` }; 
  },
  {
    connection: redis as any,
  }
);

exportWorker.on('completed', (job) => {
  console.log(`[Job Completed] ${job.id} has completed successfully!`);
});

exportWorker.on('failed', (job, err) => {
  console.error(`[Job Failed] ${job?.id} failed with ${err.message}`);
});
