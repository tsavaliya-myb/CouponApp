import { Router } from 'express';
import { CitiesController } from './cities.controller';
import { validate } from '../../../shared/middlewares/validate';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import {
  createCitySchema,
  updateCitySchema,
  createAreaSchema,
  updateAreaSchema,
} from './cities.validator';

import './cities.swagger';

const router = Router();
const controller = new CitiesController();

// ─── PUBLIC ROUTES (no token required) ───────────────────────────────────────

router.get('/', controller.getCities);

router.get(
  '/:cityId/areas',
  controller.getAreas
);

// ─── PROTECTED ROUTES (Admin only) ───────────────────────────────────────────

router.use(authenticate, authorize('admin'));

// ─── CITIES ───────────────────────────────────────────────────────────────────

router.post(
  '/',
  validate(createCitySchema),
  controller.createCity
);

router.patch(
  '/:id',
  validate(updateCitySchema),
  controller.updateCity
);

router.post(
  '/:cityId/areas',
  validate(createAreaSchema),
  controller.createArea
);

// ─── AREAS (Direct / Standalone updates) ──────────────────────────────────────
// Wait, the specification says PATCH /api/v1/admin/areas/:id
// To keep the router prefix clean (which is /admin/cities based on Phase 2 plan), 
// we'll actually need two routers exported from here, or one mounted slightly differently.
// Let's export an `areasRouter` as well to strictly match the URI in the brief.

import { AdminCouponsController } from '../coupons/admin-coupons.controller';
import { syncBaseCouponsSchema } from '../coupons/admin-coupons.validator';

// ... (other imports stay the same, assuming we attach it directly after existing routes)

const adminCouponsController = new AdminCouponsController();

// ─── Base Coupons (Phase 6 Admin) ─────────────────────────────────────────────
router.get(
  '/:cityId/base-coupons',
  adminCouponsController.getCityBaseCoupons
);

router.post(
  '/:cityId/base-coupons',
  validate(syncBaseCouponsSchema),
  adminCouponsController.syncCityBaseCoupons
);

export { router as citiesRouter };

// ─── Standalone Areas Router ──────────────────────────────────────────────────
// For PATCH /api/v1/admin/areas/:id
const areasRouter = Router();

areasRouter.use(authenticate, authorize('admin'));

areasRouter.patch(
  '/:id',
  validate(updateAreaSchema),
  controller.updateArea
);

export { areasRouter };
