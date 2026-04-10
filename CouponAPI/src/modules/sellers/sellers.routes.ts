import { Router } from 'express';
import { SellersController } from './sellers.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { requireSubscription } from '../../shared/middlewares/subscription';
import { upload } from '../../shared/middlewares/upload';
import {
  registerSellerSchema,
  updateSellerSchema,
  findSellersSchema,
  getSellersByAreaCategorySchema,
  getSellerMediaSchema,
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

router.get(
  '/by-area-category',
  authenticate,
  validate(getSellersByAreaCategorySchema, 'query'),
  controller.getSellersByAreaCategory
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

sellerOnlyRouter.post('/me/logo', upload.single('logo'), controller.uploadLogo);
sellerOnlyRouter.post(
  '/me/media', 
  upload.fields([
    { name: 'photo1', maxCount: 1 },
    { name: 'photo2', maxCount: 1 },
    { name: 'video', maxCount: 1 },
  ]), 
  controller.uploadMedia
);

router.use(sellerOnlyRouter);

export { router as sellersRouter };
