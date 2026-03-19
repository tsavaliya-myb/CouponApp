import { Request, Response, NextFunction } from 'express';
import { AdminSellersService } from './admin-sellers.service';
import { sendSuccess } from '../../../shared/utils/response';
import type { AdminSellersQueryDto } from './admin-sellers.validator';

const adminSellersService = new AdminSellersService();

export class AdminSellersController {
  
  listSellers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as AdminSellersQueryDto;
      const result = await adminSellersService.listSellers(query);
      
      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };

  approveSeller = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const seller = await adminSellersService.approveSeller(req.params.id as string);
      sendSuccess(res, seller);
    } catch (err) {
      next(err);
    }
  };

  suspendSeller = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const seller = await adminSellersService.suspendSeller(req.params.id as string);
      sendSuccess(res, seller);
    } catch (err) {
      next(err);
    }
  };

  editSeller = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const seller = await adminSellersService.editSeller(req.params.id as string, req.body);
      sendSuccess(res, seller);
    } catch (err) {
      next(err);
    }
  };
}
