import { Router } from 'express';
import { AuthController } from './auth.controller';
import { validate } from '../../shared/middlewares/validate';
import {
  adminLoginSchema,
  refreshSchema,
  logoutSchema,
  sendOtpSchema,
  verifyOtpSchema,
} from './auth.validator';
import './auth.swagger';

const router = Router();
const authController = new AuthController();

/**
 * @route   POST /api/v1/auth/send-otp
 * @desc    Send a 6-digit OTP to a user's phone number
 * @access  Public
 */
router.post(
  '/send-otp',
  validate(sendOtpSchema),
  authController.sendOtp
);

/**
 * @route   POST /api/v1/auth/verify-otp
 * @desc    Verify a 6-digit OTP and establish session
 * @access  Public
 */
router.post(
  '/verify-otp',
  validate(verifyOtpSchema),
  authController.verifyOtp
);

/**
 * @route   POST /api/v1/auth/admin/login
 * @desc    Admin login with email + password — returns JWT access + refresh token pair
 * @access  Public
 */
router.post(
  '/admin/login',
  validate(adminLoginSchema),
  authController.adminLogin
);

/**
 * @route   POST /api/v1/auth/refresh
 * @desc    Exchange a valid refresh token for a new access token
 * @access  Public (refresh token in body)
 */
router.post(
  '/refresh',
  validate(refreshSchema),
  authController.refresh
);

/**
 * @route   POST /api/v1/auth/logout
 * @desc    Invalidate a refresh token (delete from Redis)
 * @access  Public (refresh token in body)
 */
router.post(
  '/logout',
  validate(logoutSchema),
  authController.logout
);

export { router as authRouter };
