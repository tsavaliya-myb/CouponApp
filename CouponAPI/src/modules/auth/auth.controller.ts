import { Request, Response, NextFunction } from 'express';
import { AuthService } from './auth.service';
import { sendSuccess } from '../../shared/utils/response';

const authService = new AuthService();

export class AuthController {

  // POST /api/v1/auth/admin/login
  adminLogin = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await authService.adminLogin(req.body);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  // POST /api/v1/auth/refresh
  refresh = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await authService.refresh(req.body);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };

  // POST /api/v1/auth/logout
  logout = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await authService.logout(req.body);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };
}
