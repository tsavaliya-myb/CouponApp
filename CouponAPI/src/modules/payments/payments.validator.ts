import { z } from 'zod';

// ─── POST /payments/initiate ──────────────────────────────────────────────────

const siDetailsSchema = z.object({
  billingAmount:    z.string(),
  billingCurrency:  z.string(),
  billingCycle:     z.string(),
  billingInterval:  z.number(),
  paymentStartDate: z.string(),
  paymentEndDate:   z.string(),
  billingRule:      z.string(),
  remarks:          z.string(),
});

export const initiatePaymentResponseSchema = z.object({
  key:            z.string(),
  txnid:          z.string(),
  amount:         z.string(),
  productinfo:    z.string(),
  firstname:      z.string(),
  email:          z.string(),
  phone:          z.string(),
  userCredential: z.string(),
  env:            z.string(),
  si_details:     siDetailsSchema,
});

export type InitiatePaymentResponse = z.infer<typeof initiatePaymentResponseSchema>;

// ─── POST /payments/generate-hash ────────────────────────────────────────────

export const generateHashRequestSchema = z.object({
  hash_string: z.string().min(1, 'hash_string is required'),
});

export const generateHashResponseSchema = z.object({
  hash: z.string(),
});

export type GenerateHashRequest  = z.infer<typeof generateHashRequestSchema>;
export type GenerateHashResponse = z.infer<typeof generateHashResponseSchema>;
