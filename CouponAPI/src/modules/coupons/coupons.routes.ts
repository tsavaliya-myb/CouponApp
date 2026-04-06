import { Router } from 'express';
import { CouponsController } from './coupons.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { requireSubscription } from '../../shared/middlewares/subscription';
import { myCouponsQuerySchema, sellerCouponsQuerySchema } from './coupons.validator';

import './coupons.swagger';

const router = Router();
const controller = new CouponsController();

// ─── Protected Routes (Customer — Subscribers Only) ───────────────────────────
router.get(
  '/',
  authenticate,
  authorize('customer'),
  requireSubscription,
  validate(myCouponsQuerySchema, 'query'),
  controller.getMyCoupons
);

// ─── Public/Customer Route ────────────────────────────────────────────────────
router.get(
  '/seller/:sellerId',
  validate(sellerCouponsQuerySchema, 'query'),
  controller.getSellerCoupons
);

export { router as couponsRouter };
