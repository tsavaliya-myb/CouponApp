import { Router } from 'express';
import { AdminDashboardController } from './dashboard.controller';
import { authenticate, authorize } from '../../../shared/middlewares/auth';
import './dashboard.swagger';

const router = Router();
const controller = new AdminDashboardController();

router.use(authenticate, authorize('admin'));
router.get('/', controller.getStats);

export { router as adminDashboardRouter };
