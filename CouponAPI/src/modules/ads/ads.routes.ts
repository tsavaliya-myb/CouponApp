import { Router } from 'express';
import { AdsController } from './ads.controller';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { validate } from '../../shared/middlewares/validate';
import {
  createBannerAdSchema,
  updateBannerAdSchema,
  adminListAdsQuerySchema,
  publicBannersQuerySchema,
} from './ads.validator';

const router = Router();
const ctrl   = new AdsController();

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC — Customer app fetches active slider banners (no auth required)
// ─────────────────────────────────────────────────────────────────────────────

/**
 * GET /api/v1/ads/banners?cityId=<uuid>
 * Returns active banners targeting the given city, ordered newest first.
 */
router.get(
  '/banners',
  validate(publicBannersQuerySchema, 'query'),
  ctrl.getActiveBanners,
);

/**
 * POST /api/v1/ads/banners/:id/impression
 * Called by Flutter whenever a banner enters the viewport.
 */
router.post('/banners/:id/impression', ctrl.recordImpression);

/**
 * POST /api/v1/ads/banners/:id/click
 * Called by Flutter when the user taps a banner.
 */
router.post('/banners/:id/click', ctrl.recordClick);

// ─────────────────────────────────────────────────────────────────────────────
// ADMIN — Full management (all routes require admin JWT)
// ─────────────────────────────────────────────────────────────────────────────

router.use(authenticate, authorize('admin'));

/**
 * POST /api/v1/ads/admin/banners
 * Admin creates a new banner ad.
 * Body: { title, sellerId?, imageUrl?, videoUrl?, actionUrl?, cityIds[], startsAt, endsAt }
 */
router.post(
  '/admin/banners',
  validate(createBannerAdSchema),
  ctrl.createAd,
);

/**
 * GET /api/v1/ads/admin/banners
 * List all ads. Query: ?status=&sellerId=&cityId=&page=&limit=
 */
router.get(
  '/admin/banners',
  validate(adminListAdsQuerySchema, 'query'),
  ctrl.adminListAds,
);

/**
 * GET /api/v1/ads/admin/banners/:id
 * Get full details of a single ad.
 */
router.get('/admin/banners/:id', ctrl.adminGetAd);

/**
 * PATCH /api/v1/ads/admin/banners/:id
 * Update ad fields (title, dates, cities, status, media).
 */
router.patch(
  '/admin/banners/:id',
  validate(updateBannerAdSchema),
  ctrl.updateAd,
);

/**
 * PATCH /api/v1/ads/admin/banners/:id/pause
 * Pause an active ad immediately.
 */
router.patch('/admin/banners/:id/pause', ctrl.pauseAd);

/**
 * PATCH /api/v1/ads/admin/banners/:id/resume
 * Resume a paused ad.
 */
router.patch('/admin/banners/:id/resume', ctrl.resumeAd);

/**
 * DELETE /api/v1/ads/admin/banners/:id
 * Permanently delete an ad (cascade-deletes city associations).
 */
router.delete('/admin/banners/:id', ctrl.deleteAd);

export { router as adsRouter };
