import { z } from 'zod';
import { PAGINATION } from '../../shared/constants';

// ─── Seller: Scan Customer QR Token ───────────────────────────────────────────
export const scanQrSchema = z.object({
  qrToken: z.string().min(10, 'Invalid QR token format'),
});

// ─── Seller: Confirm Redemption ───────────────────────────────────────────────
export const confirmRedemptionSchema = z.object({
  qrToken: z.string(), // Re-verify to ensure session hasn't expired
  userCouponId: z.string().uuid(),
  billAmount: z.number().positive(),
  discountAmount: z.number().min(0),
  coinsUsed: z.number().int().min(0).default(0),
});

// ─── History Queries ──────────────────────────────────────────────────────────
export const redemptionHistoryQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  period: z.enum(['this_week', 'this_month', 'all']).default('all'),
});

export type ScanQrDto = z.infer<typeof scanQrSchema>;
export type ConfirmRedemptionDto = z.infer<typeof confirmRedemptionSchema>;
export type RedemptionHistoryQueryDto = z.infer<typeof redemptionHistoryQuerySchema>;
