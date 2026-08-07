import { z } from 'zod';

// ─── POST /payments/initiate ──────────────────────────────────────────────────

export const initiatePaymentResponseSchema = z.object({
  keyId:       z.string(),
  orderId:     z.string(),
  customerId:  z.string(),
  amount:      z.number().int(),
  currency:    z.literal('INR'),
  name:        z.string(),
  description: z.string(),
  recurring:   z.literal('1'),
  prefill: z.object({
    name:    z.string(),
    email:   z.string(),
    contact: z.string(),
  }),
});

export type InitiatePaymentResponse = z.infer<typeof initiatePaymentResponseSchema>;

// ─── POST /payments/verify ────────────────────────────────────────────────────

export const verifyPaymentRequestSchema = z.object({
  razorpay_order_id:   z.string().min(1, 'razorpay_order_id is required'),
  razorpay_payment_id: z.string().min(1, 'razorpay_payment_id is required'),
  razorpay_signature:  z.string().min(1, 'razorpay_signature is required'),
});

export const verifyPaymentResponseSchema = z.object({
  status: z.string(),
});

export type VerifyPaymentRequest  = z.infer<typeof verifyPaymentRequestSchema>;
export type VerifyPaymentResponse = z.infer<typeof verifyPaymentResponseSchema>;
