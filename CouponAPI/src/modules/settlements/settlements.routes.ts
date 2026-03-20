import { Router } from 'express';
import { SettlementsController } from './settlements.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { settlementsQuerySchema } from './settlements.validator';

import './settlements.swagger';

const router = Router();
const controller = new SettlementsController();

// ─── Protected Routes (Seller) ────────────────────────────────────────────────
router.use(authenticate, authorize('seller'));

router.get(
  '/',
  validate(settlementsQuerySchema),
  controller.getMySettlements
);

router.get(
  '/week/:weekId/summary',
  controller.getSettlementDetail
);

export { router as settlementsRouter };
