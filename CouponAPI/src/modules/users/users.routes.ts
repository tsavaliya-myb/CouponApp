import { Router } from 'express';
import { UsersController } from './users.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate } from '../../shared/middlewares/auth';
import { registerUserSchema, updateUserSchema } from './users.validator';

import './users.swagger';

const router = Router();
const controller = new UsersController();

// ─── Public Routes ────────────────────────────────────────────────────────────
router.post(
  '/register',
  validate(registerUserSchema),
  controller.register
);

// ─── Protected Routes (Customers) ─────────────────────────────────────────────
router.use(authenticate);

router.get(
  '/me',
  controller.getProfile
);

router.patch(
  '/me',
  validate(updateUserSchema),
  controller.updateProfile
);

export { router as usersRouter };
