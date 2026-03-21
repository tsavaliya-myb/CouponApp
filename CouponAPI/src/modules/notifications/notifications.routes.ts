import { Router } from 'express';
import { NotificationsController } from './notifications.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { sendNotificationSchema, getHistorySchema } from './notifications.validator';

import './notifications.swagger';

const router = Router();
const controller = new NotificationsController();

// ─── ADMIN NOTIFICATIONS ────────────────────────────────────────────────────────
router.use(authenticate, authorize('admin'));

router.post('/send', validate(sendNotificationSchema), controller.send);
router.get('/history', validate(getHistorySchema, 'query'), controller.getHistory);

export { router as adminNotificationsRouter };
