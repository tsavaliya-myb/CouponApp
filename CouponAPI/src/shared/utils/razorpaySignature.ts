import crypto from 'crypto';

/**
 * Webhook signature check.
 * Formula: HMAC_SHA256(rawBody, webhookSecret) === X-Razorpay-Signature
 * `rawBody` MUST be the untouched request body bytes — re-serializing parsed
 * JSON will not byte-match what Razorpay signed.
 */
export function verifyWebhookSignature(
  rawBody: Buffer | string,
  signature: string,
  secret: string,
): boolean {
  if (!signature || !secret) return false;
  const expected = crypto.createHmac('sha256', secret).update(rawBody).digest('hex');
  const a = Buffer.from(expected, 'utf8');
  const b = Buffer.from(signature, 'utf8');
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

/**
 * Checkout success-callback signature check (client-submitted verify step).
 * Formula: HMAC_SHA256(`${orderId}|${paymentId}`, keySecret) === signature
 */
export function verifyPaymentSignature(
  orderId: string,
  paymentId: string,
  signature: string,
  keySecret: string,
): boolean {
  if (!signature) return false;
  const expected = crypto
    .createHmac('sha256', keySecret)
    .update(`${orderId}|${paymentId}`)
    .digest('hex');
  const a = Buffer.from(expected, 'utf8');
  const b = Buffer.from(signature, 'utf8');
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}
