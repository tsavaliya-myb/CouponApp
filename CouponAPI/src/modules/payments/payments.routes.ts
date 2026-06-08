import { Router } from 'express';
import express from 'express';
import { PaymentController } from './payments.controller';
import { authenticate } from '../../shared/middlewares/auth';
import './payments.swagger';

const router = Router();
const paymentController = new PaymentController();

/**
 * @route   POST /api/v1/payments/initiate
 * @desc    Generate PayU hash + SI details; Flutter opens PayU CheckoutPro
 * @access  Private (Customer)
 */
router.post('/initiate', authenticate, paymentController.initiatePayment);

/**
 * @route   POST /api/v1/payments/generate-hash
 * @desc    Compute SHA-512 hash server-side for PayU SDK's generateHash callback
 * @access  Private (Customer) — salt never sent to client
 */
router.post('/generate-hash', authenticate, paymentController.generateHash);

/**
 * @route   POST /api/v1/payments/webhook
 * @desc    PayU S2S webhook — fulfils subscription on successful mandate
 * @access  Public (PayU servers only — validated via reverse SHA-512 hash)
 * @note    PayU sends application/x-www-form-urlencoded, NOT JSON
 */
router.post(
  '/webhook',
  express.urlencoded({ extended: true }),
  paymentController.webhook,
);

/**
 * @route   POST /api/v1/payments/cancel-autopay
 * @desc    Cancel the UPI autopay mandate securely via PayU API
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
