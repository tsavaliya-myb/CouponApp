import { Router } from 'express';
import { InfluencersController } from './influencers.controller';
import { validate } from '../../shared/middlewares/validate';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { requireSubscription } from '../../shared/middlewares/subscription';
import {
  registerInfluencerSchema,
  updateInfluencerSchema,
  findInfluencersSchema,
  createServiceSchema,
  updateServiceSchema,
  createBookingSchema,
  updateBookingStatusSchema,
} from './influencers.validator';

import './influencers.swagger';

const router = Router();
const controller = new InfluencersController();

// ─── Public / Initial Setup ───────────────────────────────────────────────────
router.post(
  '/register',
  validate(registerInfluencerSchema),
  controller.register
);

router.get(
  '/niches',
  controller.getActiveNiches
);

// ─── Customer Routes (Authenticated Users) ────────────────────────────────────
const customerRouter = Router();
customerRouter.use(authenticate);

customerRouter.get(
  '/',
  validate(findInfluencersSchema, 'query'),
  controller.findInfluencers
);

customerRouter.get(
  '/me/bookings',
  controller.getUserBookings
);

customerRouter.get(
  '/:id',
  requireSubscription,
  controller.getPublicProfile
);

customerRouter.post(
  '/book',
  requireSubscription,
  validate(createBookingSchema),
  controller.createBooking
);

router.use(customerRouter);

// ─── Influencer Protected Routes ──────────────────────────────────────────────
const influencerRouter = Router();
influencerRouter.use(authenticate, authorize('influencer'));

influencerRouter.get('/me', controller.getProfile);
influencerRouter.patch('/me', validate(updateInfluencerSchema), controller.updateProfile);
influencerRouter.get('/me/dashboard', controller.getDashboard);

// Services Management
influencerRouter.get('/me/services', controller.getMyServices);
influencerRouter.post('/me/services', validate(createServiceSchema), controller.addService);
influencerRouter.patch('/me/services/:id', validate(updateServiceSchema), controller.updateService);
influencerRouter.post('/me/services/:id/toggle-status', controller.toggleServiceStatus);
influencerRouter.delete('/me/services/:id', controller.deleteService);

// Bookings Management
influencerRouter.get('/me/bookings', controller.getMyIncomingBookings);
influencerRouter.patch('/me/bookings/:id', validate(updateBookingStatusSchema), controller.updateBookingStatus);

// Note: Photo/Cover upload routes can be added similar to seller media using presigned S3 URLs

router.use(influencerRouter);

export { router as influencersRouter };
