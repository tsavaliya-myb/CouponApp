import { Router } from 'express';
import { PaymentController } from './payments.controller';
import { authenticate } from '../../shared/middlewares/auth';
import { razorpayWebhookSignature } from '../../shared/middlewares/razorpayWebhook.middleware';
import './payments.swagger';

const router = Router();
const paymentController = new PaymentController();

/**
 * @route   POST /api/v1/payments/create-order
 * @desc    Create a Razorpay order for subscription purchase
 * @access  Private (Customer)
 */
router.post('/create-order', authenticate, paymentController.createOrder);

/**
 * @route   POST /api/v1/payments/webhook
 * @desc    Razorpay payment webhook — fulfils subscription on payment.captured
 * @access  Public (Razorpay servers only — validated via HMAC signature)
 */
router.post('/webhook', razorpayWebhookSignature, paymentController.webhook);

export { router as paymentsRouter };
