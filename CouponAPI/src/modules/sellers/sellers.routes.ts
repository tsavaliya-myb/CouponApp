import { Router } from 'express';
import { SellersController } from './sellers.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { requireSubscription } from '../../shared/middlewares/subscription';
import {
  registerSellerSchema,
  updateSellerSchema,
  findSellersSchema,
  getSellersByCityCategorySchema,
  getSellerMediaSchema,
  presignLogoSchema,
  confirmLogoSchema,
  presignMediaSchema,
  confirmMediaSchema,
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

// ─── Customer Routes ───────────────────────────────────────────────────────────
router.get(
  '/',
  authenticate,
  validate(findSellersSchema, 'query'),
  controller.findSellers
);

router.get(
  '/by-city-category',
  authenticate,
  validate(getSellersByCityCategorySchema, 'query'),
  controller.getSellersByCityCategory
);

router.post(
  '/media',
  authenticate,
  requireSubscription,
  validate(getSellerMediaSchema),
  controller.getSellerMedia
);

// ─── Protected Routes (Sellers Only) ──────────────────────────────────────────
const sellerOnlyRouter = Router();
sellerOnlyRouter.use(authenticate, authorize('seller'));

sellerOnlyRouter.get('/me', controller.getProfile);
sellerOnlyRouter.patch('/me', validate(updateSellerSchema), controller.updateProfile);
sellerOnlyRouter.get('/me/dashboard', controller.getDashboard);

// Logo upload — presign then confirm (Flutter uploads directly to iDrive E2)
sellerOnlyRouter.post('/me/logo/presign', validate(presignLogoSchema), controller.presignLogo);
sellerOnlyRouter.post('/me/logo/confirm', validate(confirmLogoSchema), controller.confirmLogo);

// Media upload — presign then confirm
sellerOnlyRouter.post('/me/media/presign', validate(presignMediaSchema), controller.presignMedia);
sellerOnlyRouter.post('/me/media/confirm', validate(confirmMediaSchema), controller.confirmMedia);

router.use(sellerOnlyRouter);

export { router as sellersRouter };
