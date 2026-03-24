import { Router } from 'express';

/**
 * Root API router — aggregates all module routers.
 * Each module registers its own routes in src/modules/<module>/routes.ts
 * and is plugged in here.
 */
export const apiRouter = Router();

// ─── Modules (added as each phase is implemented) ───────────────────────────

// Phase 1: Auth
import { authRouter } from '../modules/auth/auth.routes';
apiRouter.use('/auth', authRouter);

// Phase 2: Cities & Areas (Admin)
import { citiesRouter, areasRouter } from '../modules/admin/cities/cities.routes';
apiRouter.use('/admin/cities', citiesRouter);
apiRouter.use('/admin/areas', areasRouter);

// Phase 3: Users
import { usersRouter } from '../modules/users/users.routes';
import { adminUsersRouter } from '../modules/admin/users/admin-users.routes';
apiRouter.use('/users', usersRouter);
apiRouter.use('/admin/users', adminUsersRouter);

// Phase 4: Sellers
import { sellersRouter } from '../modules/sellers/sellers.routes';
import { adminSellersRouter } from '../modules/admin/sellers/admin-sellers.routes';
apiRouter.use('/sellers', sellersRouter);
apiRouter.use('/admin/sellers', adminSellersRouter);

// Phase 5: Payments
import { paymentsRouter } from '../modules/payments/payments.routes';
apiRouter.use('/payments', paymentsRouter);

// Phase 6: Coupons
import { couponsRouter } from '../modules/coupons/coupons.routes';
import { adminCouponsRouter } from '../modules/admin/coupons/admin-coupons.routes';
apiRouter.use('/coupons', couponsRouter);
apiRouter.use('/admin/coupons', adminCouponsRouter);

// Phase 7: Redemptions
import { redemptionsRouter } from '../modules/redemptions/redemptions.routes';
apiRouter.use('/redemptions', redemptionsRouter);

// Phase 8: Wallet
import { walletRouter } from '../modules/wallet/wallet.routes';
import { adminWalletRouter } from '../modules/admin/wallet/admin-wallet.routes';
apiRouter.use('/wallet', walletRouter);
apiRouter.use('/admin/wallet', adminWalletRouter);

// Phase 9: Settlements
import { settlementsRouter } from '../modules/settlements/settlements.routes';
import { adminSettlementsRouter } from '../modules/admin/settlements/admin-settlements.routes';
apiRouter.use('/settlements', settlementsRouter);
apiRouter.use('/admin/settlements', adminSettlementsRouter);

// Phase 10: Analytics
import { adminAnalyticsRouter } from '../modules/analytics/analytics.routes';
apiRouter.use('/admin/analytics', adminAnalyticsRouter);

// Phase 11: Notifications
import { adminNotificationsRouter } from '../modules/notifications/notifications.routes';
apiRouter.use('/admin/notifications', adminNotificationsRouter);

// Phase 12: App Settings
import { adminSettingsRouter } from '../modules/admin/settings/settings.routes';
apiRouter.use('/admin/settings', adminSettingsRouter);

// Phase 13: Dashboards
import { adminDashboardRouter } from '../modules/admin/dashboard/dashboard.routes';
import { sellerDashboardRouter } from '../modules/sellers/dashboard/dashboard.routes';
apiRouter.use('/admin/dashboard', adminDashboardRouter);
apiRouter.use('/sellers/me/dashboard', sellerDashboardRouter);
