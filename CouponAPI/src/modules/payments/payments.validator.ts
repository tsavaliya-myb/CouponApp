import { z } from 'zod';

// ─── Create Order ─────────────────────────────────────────────────────────────
// No body needed — price comes from AppSetting, userId from JWT
export const createOrderResponseSchema = z.object({
  orderId: z.string(),
  amount: z.number().int(), // in paise
  currency: z.string(),
  keyId: z.string(),
});

export type CreateOrderResponse = z.infer<typeof createOrderResponseSchema>;
