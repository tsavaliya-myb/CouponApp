import { Request, Response, NextFunction } from 'express';
import { AdminUsersService } from './admin-users.service';
import { sendSuccess } from '../../../shared/utils/response';
import type { AdminUsersQueryDto } from './admin-users.validator';

const adminUsersService = new AdminUsersService();

export class AdminUsersController {
  
  // ─── List Users ───────────────────────────────────────────────────────────────
  listUsers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      // req.query is validated and parsed by Zod middleware
      const query = req.query as unknown as AdminUsersQueryDto;
      const result = await adminUsersService.listUsers(query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };

  // ─── Get User Details ─────────────────────────────────────────────────────────
  getUserDetails = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const user = await adminUsersService.getUserDetails(req.params.id as string);
      sendSuccess(res, user);
    } catch (err) {
      next(err);
    }
  };

  // ─── Block / Unblock User ─────────────────────────────────────────────────────
  toggleBlockStatus = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const user = await adminUsersService.toggleBlockStatus(req.params.id as string);
      sendSuccess(res, user);
    } catch (err) {
      next(err);
    }
  };

  // ─── Manually Award Coins ─────────────────────────────────────────────────────
  awardCoins = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const transaction = await adminUsersService.awardCoins(req.params.id as string, req.body);
      
      res.status(200).json({
        success: true,
        data: {
          message: `Successfully awarded ${transaction.amount} coins.`,
          transaction,
        },
      });
    } catch (err) {
      next(err);
    }
  };
}
