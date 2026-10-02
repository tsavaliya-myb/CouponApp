import { Router } from 'express';
import { AdminInfluencersController } from './admin-influencers.controller';
import { validate } from '../../../shared/middlewares/validate';
import { adminInfluencersQuerySchema, adminUpdateInfluencerSchema, adminBookingsQuerySchema } from './admin-influencers.validator';

const router = Router();
const controller = new AdminInfluencersController();

// Lists
router.get('/', validate(adminInfluencersQuerySchema, 'query'), controller.listInfluencers);
router.get('/bookings', validate(adminBookingsQuerySchema, 'query'), controller.listBookings);

// Individual Influencer Actions
router.get('/:id', controller.getInfluencer);
router.patch('/:id', validate(adminUpdateInfluencerSchema), controller.editInfluencer);

// Lifecycle
router.post('/:id/approve', controller.approveInfluencer);
router.post('/:id/suspend', controller.suspendInfluencer);
router.post('/:id/reject', controller.rejectInfluencer);

export { router as adminInfluencersRouter };
