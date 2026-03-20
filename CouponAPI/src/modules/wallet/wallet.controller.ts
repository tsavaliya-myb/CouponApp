import { Request, Response, NextFunction } from 'express';
import { WalletService } from './wallet.service';
import type { WalletHistoryQueryDto } from './wallet.validator';

const walletService = new WalletService();

export class WalletController {
  
  getWallet = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as WalletHistoryQueryDto;
      const result = await walletService.getWallet(req.user!.userId, query);
      
      res.status(200).json({
        success: true,
        data: result,
      });
    } catch (err) {
      next(err);
    }
  };
}
