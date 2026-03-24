import crypto from 'crypto';
import { Request, Response, NextFunction } from 'express';
import { env } from '../../config/env';
import { AppError } from '../utils/AppError';

/**
 * Verifies the Razorpay webhook signature using HMAC SHA256.
 * Must come BEFORE express.json() parses the body — the rawBody buffer
 * is captured in app.ts via the express.json `verify` callback.
 */
export function razorpayWebhookSignature(
  req: Request & { rawBody?: Buffer },
  _res: Response,
  next: NextFunction
): void {
  const signature = req.headers['x-razorpay-signature'] as string | undefined;

  if (!signature) {
    return next(new AppError('Missing Razorpay signature header', 400, 'WEBHOOK_MISSING_SIGNATURE'));
  }

  if (!req.rawBody) {
    return next(new AppError('Raw body not available for webhook verification', 500, 'WEBHOOK_NO_RAW_BODY'));
  }

  const expectedSignature = crypto
    .createHmac('sha256', env.RAZORPAY_WEBHOOK_SECRET)
    .update(req.rawBody)
    .digest('hex');

  if (!crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSignature))) {
    return next(new AppError('Invalid webhook signature', 400, 'WEBHOOK_INVALID_SIGNATURE'));
  }

  next();
}
