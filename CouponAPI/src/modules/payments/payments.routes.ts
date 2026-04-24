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

export { router as paymentsRouter };
