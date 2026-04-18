import { Router } from 'express';
import { AdminCategoriesController } from './admin-categories.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { createCategorySchema, updateCategorySchema } from './admin-categories.validator';

import './admin-categories.swagger';

const controller = new AdminCategoriesController();

// ─── Public router (GET /categories) ─────────────────────────────────────────
export const categoriesRouter = Router();
categoriesRouter.get('/', controller.listCategories);

// ─── Admin router (/admin/categories) ────────────────────────────────────────
export const adminCategoriesRouter = Router();

adminCategoriesRouter.get('/', controller.listCategories);

adminCategoriesRouter.use(authenticate, authorize('admin'));

adminCategoriesRouter.post(
  '/',
  validate(createCategorySchema),
  controller.createCategory,
);

adminCategoriesRouter.patch(
  '/:id',
  validate(updateCategorySchema),
  controller.updateCategory,
);
