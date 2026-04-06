import { Router } from 'express';
import { RedemptionsController } from './redemptions.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { requireSubscription } from '../../shared/middlewares/subscription';
import { confirmRedemptionSchema, redemptionHistoryQuerySchema } from './redemptions.validator';

import './redemptions.swagger';

const router = Router();
const controller = new RedemptionsController();

// ─── Protected Routes (Customer) ──────────────────────────────────────────────
router.get(
  '/history',
  authenticate,
  authorize('customer'),
  requireSubscription,
  validate(redemptionHistoryQuerySchema, 'query'),
  controller.getUserHistory
);

// ─── Protected Routes (Seller) ────────────────────────────────────────────────
router.get(
  '/seller/history',
  authenticate,
  authorize('seller'),
  validate(redemptionHistoryQuerySchema, 'query'),
  controller.getSellerHistory
);

router.get(
  '/verifyUser/:userId',
  authenticate,
  authorize('seller'),
  controller.verifyUser
);

router.post(
  '/confirm',
  authenticate,
  authorize('seller'),
  validate(confirmRedemptionSchema),
  controller.confirmRedemption
);

export { router as redemptionsRouter };
