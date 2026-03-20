import { Router } from 'express';
import { SellerDashboardController } from './dashboard.controller';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import './dashboard.swagger';

const router = Router();
const controller = new SellerDashboardController();

// ─── SELLER DASHBOARD ───────────────────────────────────────────────────────
router.use(authenticate, authorize('seller'));
router.get('/', controller.getStats);

export { router as sellerDashboardRouter };
