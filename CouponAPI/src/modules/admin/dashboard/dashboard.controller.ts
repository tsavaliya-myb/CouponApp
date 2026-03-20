import { Request, Response, NextFunction } from 'express';
import { adminDashboardService } from './dashboard.service';
import { sendSuccess } from '../../../shared/utils/response';

export class AdminDashboardController {
  getStats = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await adminDashboardService.getDashboardStats();
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };
}
