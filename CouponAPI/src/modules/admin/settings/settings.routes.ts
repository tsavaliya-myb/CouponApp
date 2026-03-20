import { Router } from 'express';
import { AppSettingsController } from './settings.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import { updateSettingsSchema } from './settings.validator';

import './settings.swagger';

const router = Router();
const controller = new AppSettingsController();

// ─── ADMIN SETTINGS ─────────────────────────────────────────────────────────
router.use(authenticate, authorize('admin'));

router.get('/', controller.getAll);
router.patch('/', validate(updateSettingsSchema), controller.updateBatch);

export { router as adminSettingsRouter };
