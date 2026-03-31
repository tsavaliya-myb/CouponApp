import { Request, Response, NextFunction } from 'express';
import { RedemptionsService } from './redemptions.service';
import { sendSuccess, sendCreated } from '../../shared/utils/response';
import type { ConfirmRedemptionDto, RedemptionHistoryQueryDto } from './redemptions.validator';

const redemptionsService = new RedemptionsService();

export class RedemptionsController {

  // ─── Seller Endpoints ─────────────────────────────────────────────────────────

  verifyUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.params.userId as string;
      const result = await redemptionsService.verifyUser(req.user!.userId, userId);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };

  confirmRedemption = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const redemption = await redemptionsService.confirmRedemption(req.user!.userId, req.body as ConfirmRedemptionDto);
      sendCreated(res, redemption);
    } catch (err) {
      next(err);
    }
  };

  getSellerHistory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as RedemptionHistoryQueryDto;
      const result = await redemptionsService.getSellerHistory(req.user!.userId, query);
      res.status(200).json({ success: true, data: result.data, meta: result.meta });
    } catch (err) {
      next(err);
    }
  };

  // ─── Customer Endpoints ───────────────────────────────────────────────────────

  getUserHistory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as RedemptionHistoryQueryDto;
      const result = await redemptionsService.getUserHistory(req.user!.userId, query);
      res.status(200).json({ success: true, data: result.data, meta: result.meta });
    } catch (err) {
      next(err);
    }
  };
}
