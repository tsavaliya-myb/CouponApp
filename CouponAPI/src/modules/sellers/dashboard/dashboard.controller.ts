import { Request, Response, NextFunction } from 'express';
import { sellerDashboardService } from './dashboard.service';
import { sendSuccess } from '../../../shared/utils/response';

export class SellerDashboardController {
  getStats = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const sellerId = req.user!.userId; // Extracted via 'seller' role middleware mapped over userId
      if (!sellerId) {
        res.status(403).json({ success: false, message: 'Not an authorized Seller' });
        return;
      }
      const stats = await sellerDashboardService.getDashboardStats(sellerId);
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };
}
