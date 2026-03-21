import { Router } from 'express';
import { SellersController } from './sellers.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import {
  registerSellerSchema,
  updateSellerSchema,
  findSellersSchema,
} from './sellers.validator';

import './sellers.swagger';

const router = Router();
const controller = new SellersController();

// ─── Public / Auth Initial Routes ─────────────────────────────────────────────
router.post(
  '/register',
  validate(registerSellerSchema),
  controller.register
);

// ─── Customer Route: Find Sellers ─────────────────────────────────────────────
// Requires authentication, but can be accessed by both 'customer' or 'admin'
router.get(
  '/',
  authenticate,
  validate(findSellersSchema, 'query'),
  controller.findSellers
);

// ─── Protected Routes (Sellers Only) ──────────────────────────────────────────
const sellerOnlyRouter = Router();
sellerOnlyRouter.use(authenticate, authorize('seller'));

sellerOnlyRouter.get('/me', controller.getProfile);
sellerOnlyRouter.patch('/me', validate(updateSellerSchema), controller.updateProfile);
sellerOnlyRouter.get('/me/dashboard', controller.getDashboard);

router.use(sellerOnlyRouter);

export { router as sellersRouter };
