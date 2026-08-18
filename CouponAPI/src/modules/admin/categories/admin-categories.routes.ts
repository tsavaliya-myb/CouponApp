import { Router } from 'express';
import { AdminCategoriesController } from './admin-categories.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import {
  createCategorySchema,
  updateCategorySchema,
  reorderCategorySchema,
  presignCategoryImageSchema,
} from './admin-categories.validator';

import './admin-categories.swagger';

const controller = new AdminCategoriesController();

// ─── Public router (GET /categories) ─────────────────────────────────────────
export const categoriesRouter = Router();
categoriesRouter.get('/', controller.listCategories);

// ─── Admin router (/admin/categories) ────────────────────────────────────────
export const adminCategoriesRouter = Router();

adminCategoriesRouter.get('/', controller.listCategories);

adminCategoriesRouter.use(authenticate, authorize('admin'));

// Presign image upload URL
adminCategoriesRouter.post(
  '/presign',
  validate(presignCategoryImageSchema),
  controller.presignCategoryImage,
);

adminCategoriesRouter.post(
  '/',
  validate(createCategorySchema),
  controller.createCategory,
);

adminCategoriesRouter.patch(
  '/reorder',
  validate(reorderCategorySchema),
  controller.reorderCategories,
);

adminCategoriesRouter.patch(
  '/:id',
  validate(updateCategorySchema),
  controller.updateCategory,
);
