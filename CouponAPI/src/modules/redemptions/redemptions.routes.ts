import { Router } from 'express';
import { RedemptionsController } from './redemptions.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { scanQrSchema, confirmRedemptionSchema, redemptionHistoryQuerySchema } from './redemptions.validator';

import './redemptions.swagger';

const router = Router();
const controller = new RedemptionsController();

// ─── Protected Routes (Customer) ──────────────────────────────────────────────
router.get(
  '/history',
  authenticate,
  authorize('customer'),
  validate(redemptionHistoryQuerySchema),
  controller.getUserHistory
);

// ─── Protected Routes (Seller) ────────────────────────────────────────────────
router.post(
  '/scan',
  authenticate,
  authorize('seller'),
  validate(scanQrSchema),
  controller.scanQrToken
);

router.post(
  '/confirm',
  authenticate,
  authorize('seller'),
  validate(confirmRedemptionSchema),
  controller.confirmRedemption
);

export { router as redemptionsRouter };
