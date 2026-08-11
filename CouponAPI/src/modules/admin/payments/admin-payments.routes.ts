import { Router } from 'express';
import { AdminPaymentsController } from './admin-payments.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { adminPaymentsQuerySchema } from './admin-payments.validator';

import './admin-payments.swagger';

const router = Router();
const controller = new AdminPaymentsController();

// All routes require Admin role
router.use(authenticate, authorize('admin'));

router.get(
  '/',
  validate(adminPaymentsQuerySchema, 'query'),
  controller.listPayments
);

export { router as adminPaymentsRouter };
