import { Request, Response, NextFunction } from 'express';
import { SettlementsService } from './settlements.service';
import { sendSuccess } from '../../shared/utils/response';
import type { SettlementsQueryDto } from './settlements.validator';

const settlementsService = new SettlementsService();

export class SettlementsController {
  
  getMySettlements = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as SettlementsQueryDto;
      const result = await settlementsService.getMySettlements(req.user!.userId, query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };

  getSettlementDetail = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      // Intentionally passing the "weekId" parameter as the primary key ID.
      const detail = await settlementsService.getSettlementDetail(req.user!.userId, req.params.weekId as string);
      sendSuccess(res, detail);
    } catch (err) {
      next(err);
    }
  };
}
