import { Request, Response, NextFunction } from 'express';
import { SellersService } from './sellers.service';
import { sendSuccess, sendCreated } from '../../shared/utils/response';
import type { FindSellersDto, GetSellersByAreaCategoryDto } from './sellers.validator';

const sellersService = new SellersService();

export class SellersController {
  
  register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await sellersService.register(req.body);
      sendCreated(res, result);
    } catch (err) {
      next(err);
    }
  };

  getProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const profile = await sellersService.getProfile(req.user!.userId);
      sendSuccess(res, profile);
    } catch (err) {
      next(err);
    }
  };

  updateProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const updatedProfile = await sellersService.updateProfile(req.user!.userId, req.body);
      sendSuccess(res, updatedProfile);
    } catch (err) {
      next(err);
    }
  };

  getDashboard = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const dbInfo = await sellersService.getDashboard(req.user!.userId);
      sendSuccess(res, dbInfo);
    } catch (err) {
      next(err);
    }
  };

  // ─── Customer-facing endpoint ───────────────────────────────────────────────
  findSellers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as FindSellersDto;
      const sellers = await sellersService.findSellersNearUser(query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };

  getSellersByAreaCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as GetSellersByAreaCategoryDto;
      const sellers = await sellersService.getSellersByAreaCategory(query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };
}
