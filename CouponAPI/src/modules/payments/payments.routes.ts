import { Router } from 'express';
import express from 'express';
import { PaymentController } from './payments.controller';
import { authenticate } from '../../shared/middlewares/auth';
import './payments.swagger';

const router = Router();
const paymentController = new PaymentController();

/**
 * @route   POST /api/v1/payments/initiate
 * @desc    Create a Razorpay order carrying UPI Autopay token params; Flutter opens Razorpay Checkout
 * @access  Private (Customer)
 */
router.post('/initiate', authenticate, paymentController.initiatePayment);

/**
 * @route   POST /api/v1/payments/verify
 * @desc    Verify the Checkout success callback's HMAC signature; optimistic fulfilment
 *          ahead of the webhook (webhook remains the source of truth)
 * @access  Private (Customer)
 */
router.post('/verify', authenticate, paymentController.verifyPayment);

/**
 * @route   POST /api/v1/payments/webhook
 * @desc    Razorpay webhook — fulfils/extends subscriptions on payment.captured,
 *          tracks failures on payment.failed, and syncs mandate state on token.* events
 * @access  Public (Razorpay servers only — validated via X-Razorpay-Signature HMAC)
 * @note    Body must stay a raw Buffer for signature verification — do NOT parse
 *          it as JSON before this middleware runs.
 */
router.post(
  '/webhook',
  express.raw({ type: 'application/json', limit: '2mb' }),
  paymentController.webhook,
);

/**
 * @route   POST /api/v1/payments/cancel-autopay
 * @desc    Cancel the UPI autopay mandate (deletes the Razorpay token) and disable renewals
 * @access  Private (Customer)
 */
router.post('/cancel-autopay', authenticate, paymentController.cancelAutopay);

/**
 * @route   GET /api/v1/payments/history
 * @desc    Fetch successful payment history and current subscription details
 * @access  Private (Customer)
 */
router.get('/history', authenticate, paymentController.getPaymentHistory);

export { router as paymentsRouter };
