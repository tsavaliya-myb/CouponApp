import { Router } from 'express';
import { AnalyticsController } from './analytics.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { analyticsSubscriptionsSchema, analyticsRedemptionsSchema, analyticsGenericLimitSchema } from './analytics.validator';

import './analytics.swagger';

const router = Router();
const controller = new AnalyticsController();

// ─── ADMIN ANALYTICS ──────────────────────────────────────────────────────────
// Entire routes grouping is isolated strictly to the App Administration framework
router.use(authenticate, authorize('admin'));

router.get('/subscriptions', validate(analyticsSubscriptionsSchema), controller.getSubscriptions);
router.get('/redemptions', validate(analyticsRedemptionsSchema), controller.getRedemptions);
router.get('/sellers/top', validate(analyticsGenericLimitSchema), controller.getTopSellers);
router.get('/coupons/top', validate(analyticsGenericLimitSchema), controller.getTopCoupons);
router.get('/coins', controller.getCoins);
router.get('/churn', controller.getChurn);

export { router as adminAnalyticsRouter };
