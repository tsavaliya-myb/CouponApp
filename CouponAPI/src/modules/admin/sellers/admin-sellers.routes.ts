import { Router } from 'express';
import { AdminSellersController } from './admin-sellers.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { adminSellersQuerySchema, adminUpdateSellerSchema } from './admin-sellers.validator';

import './admin-sellers.swagger';

const router = Router();
const controller = new AdminSellersController();

// ─── Protected Routes (Admin Only) ────────────────────────────────────────────
router.use(authenticate, authorize('admin'));

router.get(
  '/',
  validate(adminSellersQuerySchema),
  controller.listSellers
);

router.patch(
  '/:id/approve',
  controller.approveSeller
);

router.patch(
  '/:id/suspend',
  controller.suspendSeller
);

router.patch(
  '/:id',
  validate(adminUpdateSellerSchema),
  controller.editSeller
);

export { router as adminSellersRouter };
