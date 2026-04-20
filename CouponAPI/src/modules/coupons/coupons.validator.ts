import { z } from 'zod';
import { PAGINATION } from '../../shared/constants';

const categoryShapeSchema = z.object({ id: z.string().uuid(), name: z.string(), slug: z.string(), iconName: z.string().nullable() });

// ─── Query for My Active Coupons (UserCoupons) ────────────────────────────────
export const myCouponsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(500).default(PAGINATION.DEFAULT_LIMIT),
  categoryId: z.string().uuid().optional(), // Filter by seller category
  sellerId: z.string().uuid().optional(),   // Filter by specific seller
  search: z.string().optional(),
});

// ─── Query for Seller's Master Coupons ────────────────────────────────────────
export const sellerCouponsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type MyCouponsQueryDto = z.infer<typeof myCouponsQuerySchema>;

export type SellerCouponsQueryDto = z.infer<typeof sellerCouponsQuerySchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const publicSellerInfoSchema = z.object({
  id: z.string().uuid(),
  businessName: z.string(),
  categoryId: z.string().uuid(),
  category: categoryShapeSchema.optional(),
  area: z.object({ name: z.string() }).nullable().optional(),
});

export const publicCouponSchema = z.object({
  id: z.string().uuid(),
  sellerId: z.string().uuid(),
  type: z.enum(['STANDARD', 'BOGO']),
  discountPct: z.number(),
  adminCommissionPct: z.number(),
  minSpend: z.number().nullable(),
  maxUsesPerBook: z.number(),
  isBaseCoupon: z.boolean(),
  status: z.enum(['ACTIVE', 'INACTIVE']),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export const userCouponResponseSchema = z.object({
  id: z.string().uuid(),
  couponBookId: z.string().uuid(),
  couponId: z.string().uuid(),
  status: z.enum(['ACTIVE', 'USED', 'EXPIRED']),
  usesRemaining: z.number(),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
  coupon: publicCouponSchema.extend({
    seller: publicSellerInfoSchema.optional(), // Might not be populated everywhere
  }).optional(),
  couponBook: z.object({
    validUntil: z.date().or(z.string()),
  }).optional(),
});

export const paginatedUserCouponsResponseSchema = z.object({
  data: z.array(userCouponResponseSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export const paginatedSellerCouponsResponseSchema = z.object({
  data: z.array(publicCouponSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export type UserCouponResponse = z.infer<typeof userCouponResponseSchema>;
export type PaginatedUserCouponsResponse = z.infer<typeof paginatedUserCouponsResponseSchema>;
export type PaginatedSellerCouponsResponse = z.infer<typeof paginatedSellerCouponsResponseSchema>;
