import { Router } from 'express';
import { AnalyticsController } from './analytics.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { analyticsSubscriptionsSchema, analyticsRedemptionsSchema, analyticsGenericLimitSchema, dateRangeSchema, analyticsRevenueSchema } from './analytics.validator';

import './analytics.swagger';

const router = Router();
const controller = new AnalyticsController();

// ─── ADMIN ANALYTICS ──────────────────────────────────────────────────────────
// Entire routes grouping is isolated strictly to the App Administration framework
router.use(authenticate, authorize('admin'));

router.get('/subscriptions', validate(analyticsSubscriptionsSchema, 'query'), controller.getSubscriptions);
router.get('/redemptions', validate(analyticsRedemptionsSchema, 'query'), controller.getRedemptions);
router.get('/sellers/top', validate(analyticsGenericLimitSchema, 'query'), controller.getTopSellers);
router.get('/coupons/top', validate(analyticsGenericLimitSchema, 'query'), controller.getTopCoupons);
router.get('/coins', controller.getCoins);
router.get('/churn', controller.getChurn);
router.get('/revenue', validate(analyticsRevenueSchema, 'query'), controller.getRevenue);
router.get('/redemptions/category', validate(dateRangeSchema, 'query'), controller.getRedemptionsByCategory);

export { router as adminAnalyticsRouter };
