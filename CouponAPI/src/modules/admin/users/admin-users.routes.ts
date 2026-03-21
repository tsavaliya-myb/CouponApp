import { Router } from 'express';
import { AdminUsersController } from './admin-users.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { adminUsersQuerySchema, awardCoinsSchema } from './admin-users.validator';

import './admin-users.swagger';

const router = Router();
const controller = new AdminUsersController();

// All routes require Admin role
router.use(authenticate, authorize('admin'));

router.get(
  '/',
  validate(adminUsersQuerySchema, 'query'),
  controller.listUsers
);

router.get(
  '/:id',
  controller.getUserDetails
);

router.patch(
  '/:id/block',
  controller.toggleBlockStatus
);

router.post(
  '/:id/coins',
  validate(awardCoinsSchema),
  controller.awardCoins
);

export { router as adminUsersRouter };
