import { Request, Response, NextFunction } from 'express';
import { AdminWalletService } from './admin-wallet.service';
import { sendSuccess } from '../../../shared/utils/response';
import type { UpdateWalletSettingsDto, BulkAwardCoinsDto } from './admin-wallet.validator';

const adminWalletService = new AdminWalletService();

export class AdminWalletController {
  
  getSettings = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const settings = await adminWalletService.getSettings();
      sendSuccess(res, settings);
    } catch (err) {
      next(err);
    }
  };

  updateSettings = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const settings = await adminWalletService.updateSettings(req.body as UpdateWalletSettingsDto);
      sendSuccess(res, settings);
    } catch (err) {
      next(err);
    }
  };

  getOverview = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const overview = await adminWalletService.getOverview();
      sendSuccess(res, overview);
    } catch (err) {
      next(err);
    }
  };

  bulkAward = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await adminWalletService.bulkAward(req.user!.userId, req.body as BulkAwardCoinsDto);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };
}
