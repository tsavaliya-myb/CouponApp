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
}
