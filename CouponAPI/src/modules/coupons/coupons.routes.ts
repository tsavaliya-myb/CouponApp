import { Router } from 'express';
import { CouponsController } from './coupons.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { myCouponsQuerySchema, sellerCouponsQuerySchema } from './coupons.validator';

import './coupons.swagger';

const router = Router();
const controller = new CouponsController();

// ─── Protected Routes (Customer) ──────────────────────────────────────────────
router.get(
  '/',
  authenticate,
  authorize('customer'),
  validate(myCouponsQuerySchema),
  controller.getMyCoupons
);

// ─── Public/Customer Route ────────────────────────────────────────────────────
router.get(
  '/seller/:sellerId',
  validate(sellerCouponsQuerySchema),
  controller.getSellerCoupons
);

export { router as couponsRouter };
