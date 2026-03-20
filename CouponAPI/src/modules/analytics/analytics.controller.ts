import { Request, Response, NextFunction } from 'express';
import { AnalyticsService } from './analytics.service';
import { sendSuccess } from '../../shared/utils/response';
import type { AnalyticsSubscriptionsQuery, AnalyticsRedemptionsQuery, AnalyticsGenericLimitQuery } from './analytics.validator';

const analyticsService = new AnalyticsService();

export class AnalyticsController {
  
  getSubscriptions = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await analyticsService.getSubscriptionsStats(req.query as unknown as AnalyticsSubscriptionsQuery);
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };

  getRedemptions = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await analyticsService.getRedemptionsStats(req.query as unknown as AnalyticsRedemptionsQuery);
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };

  getTopSellers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await analyticsService.getTopSellers(req.query as unknown as AnalyticsGenericLimitQuery);
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };

  getTopCoupons = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await analyticsService.getTopCoupons(req.query as unknown as AnalyticsGenericLimitQuery);
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };

  getCoins = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await analyticsService.getCoinStats();
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };

  getChurn = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await analyticsService.getChurnStats();
      sendSuccess(res, stats);
    } catch (err) { next(err); }
  };
}
