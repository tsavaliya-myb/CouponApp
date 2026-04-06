import { Router } from 'express';
import { WalletController } from './wallet.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { requireSubscription } from '../../shared/middlewares/subscription';
import { walletHistoryQuerySchema } from './wallet.validator';

import './wallet.swagger';

const router = Router();
const controller = new WalletController();

// ─── Protected Routes (Customer — Subscribers Only) ───────────────────────────
router.get(
  '/',
  authenticate,
  authorize('customer'),
  requireSubscription,
  validate(walletHistoryQuerySchema, 'query'),
  controller.getWallet
);

export { router as walletRouter };
