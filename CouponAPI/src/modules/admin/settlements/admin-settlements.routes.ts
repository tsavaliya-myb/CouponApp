import { Router } from 'express';
import { AdminSettlementsController } from './admin-settlements.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { pendingSettlementsQuerySchema, markPaidSchema } from './admin-settlements.validator';

import './admin-settlements.swagger';

const router = Router();
const controller = new AdminSettlementsController();

// ─── Protected Routes (Admin Only) ────────────────────────────────────────────
router.use(authenticate, authorize('admin'));

router.get(
  '/',
  validate(pendingSettlementsQuerySchema),
  controller.getPendingSettlements
);

router.patch(
  '/:id/mark-paid',
  validate(markPaidSchema),
  controller.markPaid
);

// ─── Phase 9 CSV Export Trigger ───────────────────────────────────────────────
router.get(
  '/export',
  controller.exportCsv
);

export { router as adminSettlementsRouter };
