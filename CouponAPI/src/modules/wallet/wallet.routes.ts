import { Router } from 'express';
import { WalletController } from './wallet.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { walletHistoryQuerySchema } from './wallet.validator';

import './wallet.swagger';

const router = Router();
const controller = new WalletController();

// ─── Protected Routes (Customer) ──────────────────────────────────────────────
router.get(
  '/',
  authenticate,
  authorize('customer'),
  validate(walletHistoryQuerySchema, 'query'),
  controller.getWallet
);

export { router as walletRouter };
