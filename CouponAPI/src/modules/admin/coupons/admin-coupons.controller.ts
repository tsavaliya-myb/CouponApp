import { Request, Response, NextFunction } from 'express';
import { AdminCouponsService } from './admin-coupons.service';
import { sendSuccess, sendCreated } from '../../../shared/utils/response';
import type { AdminCouponsQueryDto, CreateCouponDto, UpdateCouponDto, SyncBaseCouponsDto } from './admin-coupons.validator';

const adminCouponsService = new AdminCouponsService();

export class AdminCouponsController {
  
  // ─── Coupons CRUD ─────────────────────────────────────────────────────────────
  listCoupons = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as AdminCouponsQueryDto;
      const result = await adminCouponsService.listCoupons(query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };

  createCoupon = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const coupon = await adminCouponsService.createCoupon(req.body as CreateCouponDto);
      sendCreated(res, coupon);
    } catch (err) {
      next(err);
    }
  };

  updateCoupon = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const coupon = await adminCouponsService.updateCoupon(req.params.id as string, req.body as UpdateCouponDto);
      sendSuccess(res, coupon);
    } catch (err) {
      next(err);
    }
  };

  deactivateCoupon = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const coupon = await adminCouponsService.deactivateCoupon(req.params.id as string);
      sendSuccess(res, coupon);
    } catch (err) {
      next(err);
    }
  };

  // ─── Base Coupons for City ────────────────────────────────────────────────────
  getCityBaseCoupons = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const coupons = await adminCouponsService.getCityBaseCoupons(req.params.cityId as string);
      sendSuccess(res, coupons);
    } catch (err) {
      next(err);
    }
  };

  syncCityBaseCoupons = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const coupons = await adminCouponsService.syncCityBaseCoupons(req.params.cityId as string, req.body as SyncBaseCouponsDto);
      sendSuccess(res, coupons);
    } catch (err) {
      next(err);
    }
  };
}
