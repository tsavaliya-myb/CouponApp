import { z } from 'zod';
import { PAGINATION } from '../../shared/constants';



// ─── Seller: Confirm Redemption ───────────────────────────────────────────────
export const confirmRedemptionSchema = z.object({
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


export type ConfirmRedemptionDto = z.infer<typeof confirmRedemptionSchema>;
export type RedemptionHistoryQueryDto = z.infer<typeof redemptionHistoryQuerySchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const verifyUserResponseSchema = z.object({
  user: z.object({
    id: z.string().uuid(),
    name: z.string().nullable(),
    phone: z.string(),
    hasActiveSubscription: z.boolean(),
    availableCoins: z.number(),
  }),
  eligibleCoupons: z.array(z.any()), // Can be typed fully with userCouponResponseSchema from coupons module if needed
});

export const baseRedemptionSchema = z.object({
  id: z.string().uuid(),
  userCouponId: z.string().uuid(),
  sellerId: z.string().uuid(),
  userId: z.string().uuid(),
  billAmount: z.number(),
  discountAmount: z.number(),
  coinsUsed: z.number(),
  finalAmount: z.number(),
  redeemedAt: z.date().or(z.string()),
});

export const confirmRedemptionResponseSchema = baseRedemptionSchema;

export const customerRedemptionHistoryResponseSchema = z.object({
  data: z.array(baseRedemptionSchema.extend({
    seller: z.object({
      businessName: z.string(),
      area: z.object({ name: z.string() }).nullable().optional(),
    }),
    userCoupon: z.object({
      coupon: z.object({
        type: z.enum(['STANDARD', 'BOGO']),
        discountPct: z.number(),
      }),
    }),
  })),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export const sellerRedemptionHistoryResponseSchema = z.object({
  data: z.array(baseRedemptionSchema.extend({
    user: z.object({
      name: z.string().nullable(),
      phone: z.string(),
    }),
    userCoupon: z.object({
      coupon: z.object({
        type: z.enum(['STANDARD', 'BOGO']),
        discountPct: z.number(),
      }),
    }),
    settlementLine: z.object({
      commissionAmt: z.number(),
      coinCompAmt: z.number(),
    }).nullable().optional(),
  })),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export type VerifyUserResponse = z.infer<typeof verifyUserResponseSchema>;
export type ConfirmRedemptionResponse = z.infer<typeof confirmRedemptionResponseSchema>;
export type CustomerRedemptionHistoryResponse = z.infer<typeof customerRedemptionHistoryResponseSchema>;
export type SellerRedemptionHistoryResponse = z.infer<typeof sellerRedemptionHistoryResponseSchema>;
