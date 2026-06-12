import { Request, Response, NextFunction } from 'express';
import { UsersService } from './users.service';
import { sendSuccess, sendCreated } from '../../shared/utils/response';

const usersService = new UsersService();

export class UsersController {

  register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await usersService.register(req.body);
      sendCreated(res, result);
    } catch (err) {
      next(err);
    }
  };

  getProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      // req.user is guaranteed to exist because of authenticate middleware
      const profile = await usersService.getProfile(req.user!.userId);
      sendSuccess(res, profile);
    } catch (err) {
      next(err);
    }
  };

  updateProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const updatedProfile = await usersService.updateProfile(req.user!.userId, req.body);
      sendSuccess(res, updatedProfile);
    } catch (err) {
      next(err);
    }
  };

  getAppSettings = async (_req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const settings = await usersService.getAppSettings();
      sendSuccess(res, settings);
    } catch (err) {
      next(err);
    }
  };

  getReferralStats = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const stats = await usersService.getReferralStats(req.user!.userId);
      sendSuccess(res, stats);
    } catch (err) {
      next(err);
    }
  };

  getLeaderboard = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const type = req.query.type as string || 'savers';
      const timeFrame = req.query.timeFrame as string || 'month';
      const leaderboard = await usersService.getLeaderboard(type, timeFrame);
      sendSuccess(res, leaderboard);
    } catch (err) {
      next(err);
    }
  };
}
