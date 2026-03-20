import { Router } from 'express';
import { AdminWalletController } from './admin-wallet.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { updateWalletSettingsSchema, bulkAwardCoinsSchema } from './admin-wallet.validator';

import './admin-wallet.swagger';

const router = Router();
const controller = new AdminWalletController();

// ─── Protected Routes (Admin Only) ────────────────────────────────────────────
router.use(authenticate, authorize('admin'));

router.get(
  '/settings',
  controller.getSettings
);

router.patch(
  '/settings',
  validate(updateWalletSettingsSchema),
  controller.updateSettings
);

router.get(
  '/overview',
  controller.getOverview
);

router.post(
  '/bulk-award',
  validate(bulkAwardCoinsSchema),
  controller.bulkAward
);

export { router as adminWalletRouter };
