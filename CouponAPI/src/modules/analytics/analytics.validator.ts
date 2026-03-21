import { z } from 'zod';

export const dateRangeSchema = z.object({
  startDate: z.string().datetime().optional(),
  endDate: z.string().datetime().optional(),
});

export const groupSchema = z.object({
  groupBy: z.enum(['day', 'week', 'month']).default('day'),
});

export const analyticsRevenueSchema = z.object({
  groupBy: z.enum(['day', 'week', 'year']).default('day'),
});

export const analyticsSubscriptionsSchema = dateRangeSchema.merge(groupSchema).extend({
  cityId: z.string().uuid().optional(),
});

export const analyticsRedemptionsSchema = dateRangeSchema.merge(groupSchema).extend({
  cityId: z.string().uuid().optional(),
  categoryId: z.string().uuid().optional(),
  sellerId: z.string().uuid().optional(),
});

export const analyticsGenericLimitSchema = dateRangeSchema.extend({
  limit: z.coerce.number().min(1).max(50).default(10),
});

export type AnalyticsRevenueQuery = z.infer<typeof analyticsRevenueSchema>;
export type AnalyticsSubscriptionsQuery = z.infer<typeof analyticsSubscriptionsSchema>;
export type AnalyticsRedemptionsQuery = z.infer<typeof analyticsRedemptionsSchema>;
export type AnalyticsGenericLimitQuery = z.infer<typeof analyticsGenericLimitSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const subscriptionStatsResponseSchema = z.object({
  totalCount: z.number(),
  totalRevenue: z.number(),
});

export const redemptionStatsResponseSchema = z.object({
  totalRedemptions: z.number(),
});

export const topSellerStatsResponseSchema = z.object({
  sellerId: z.string().nullable(),
  businessName: z.string(),
  redemptions: z.number(),
});

export const topCouponStatsResponseSchema = z.object({
  userCouponId: z.string().nullable(),
  title: z.string(),
  type: z.enum(['STANDARD', 'BOGO']).optional(),
  redemptions: z.number(),
});

export const coinStatsResponseSchema = z.object({
  totalAwarded: z.number(),
  awardedTxCount: z.number(),
  totalUsed: z.number(),
  usedTxCount: z.number(),
});

export const churnStatsResponseSchema = z.object({
  activeSubscriptions: z.number(),
  expiredSubscriptions: z.number(),
});

export const revenueStatsResponseSchema = z.array(z.object({
  label: z.string(),
  subscriptionRevenue: z.number(),
  commissionRevenue: z.number(),
  totalRevenue: z.number(),
}));

export const redemptionByCategoryResponseSchema = z.array(z.object({
  category: z.string(),
  redemptions: z.number(),
}));

export type SubscriptionStatsResponse = z.infer<typeof subscriptionStatsResponseSchema>;
export type RedemptionStatsResponse = z.infer<typeof redemptionStatsResponseSchema>;
export type TopSellerStatsResponse = z.infer<typeof topSellerStatsResponseSchema>;
export type TopCouponStatsResponse = z.infer<typeof topCouponStatsResponseSchema>;
export type CoinStatsResponse = z.infer<typeof coinStatsResponseSchema>;
export type ChurnStatsResponse = z.infer<typeof churnStatsResponseSchema>;
export type RevenueStatsResponse = z.infer<typeof revenueStatsResponseSchema>;
export type RedemptionByCategoryResponse = z.infer<typeof redemptionByCategoryResponseSchema>;
