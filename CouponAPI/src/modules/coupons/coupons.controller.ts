import { Request, Response, NextFunction } from 'express';
import { CouponsService } from './coupons.service';
import type { MyCouponsQueryDto, SellerCouponsQueryDto } from './coupons.validator';

const couponsService = new CouponsService();

export class CouponsController {
  
  getMyCoupons = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as MyCouponsQueryDto;
      const result = await couponsService.getMyCoupons(req.user!.userId, query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };

  getSellerCoupons = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as SellerCouponsQueryDto;
      const result = await couponsService.getSellerCoupons(req.params.sellerId as string, query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };
}
