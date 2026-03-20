import { Request, Response, NextFunction } from 'express';
import { AdminSettlementsService } from './admin-settlements.service';
import { sendSuccess } from '../../../shared/utils/response';
import type { PendingSettlementsQueryDto, MarkPaidDto } from './admin-settlements.validator';
import { exportQueue } from '../../../jobs/export.queue';

const adminSettlementsService = new AdminSettlementsService();

export class AdminSettlementsController {
  
  getPendingSettlements = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as PendingSettlementsQueryDto;
      const result = await adminSettlementsService.getPendingSettlements(query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };

  markPaid = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await adminSettlementsService.markSettlementPaid(req.params.id as string, req.body as MarkPaidDto);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };

  exportCsv = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const job = await exportQueue.add('export-csv', { adminId: req.user!.userId });
      
      res.status(202).json({
        success: true,
        message: 'CSV Export job dispatched successfully.',
        data: {
          jobId: job.id,
          // Since it's a mock MVP filesystem approach, the URL is theoretical
          downloadEndpoint: `/api/v1/downloads/settlements_export_${job.id}.csv`
        }
      });
    } catch (err) {
      next(err);
    }
  };
}
