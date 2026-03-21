import { Router } from 'express';
import { AdminCouponsController } from './admin-coupons.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { adminCouponsQuerySchema, createCouponSchema, updateCouponSchema } from './admin-coupons.validator';

import './admin-coupons.swagger';

const router = Router();
const controller = new AdminCouponsController();

// ─── Protected Routes (Admin Only) ────────────────────────────────────────────
router.use(authenticate, authorize('admin'));

router.get(
  '/',
  validate(adminCouponsQuerySchema, 'query'),
  controller.listCoupons
);

router.post(
  '/',
  validate(createCouponSchema),
  controller.createCoupon
);

router.patch(
  '/:id',
  validate(updateCouponSchema),
  controller.updateCoupon
);

router.patch(
  '/:id/toggle-status',
  controller.toggleCouponStatus
);

export { router as adminCouponsRouter };
