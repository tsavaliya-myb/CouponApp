import { z } from 'zod';
import { CouponType } from '@prisma/client';
import { PAGINATION } from '../../../shared/constants';

// ─── Query Params Validation for Admin Coupons List ───────────────────────────
export const adminCouponsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  sellerId: z.string().uuid().optional(),
  cityId: z.string().uuid().optional(),
  type: z.nativeEnum(CouponType).optional(),
});

// ─── Body Validation for Create Coupon ────────────────────────────────────────
export const createCouponSchema = z.object({
  sellerId: z.string().uuid(),
  discountPct: z.number().min(0).max(100),
  adminCommissionPct: z.number().min(0).max(100).optional(),
  minSpend: z.number().min(0).optional().nullable(),
  maxUsesPerBook: z.number().int().min(1).optional(),
  type: z.nativeEnum(CouponType).optional(),
  isBaseCoupon: z.boolean().optional(),
});

// ─── Body Validation for Update Coupon ────────────────────────────────────────
export const updateCouponSchema = z.object({
  discountPct: z.number().min(0).max(100).optional(),
  adminCommissionPct: z.number().min(0).max(100).optional(),
  minSpend: z.number().min(0).optional().nullable(),
  maxUsesPerBook: z.number().int().min(1).optional(),
  type: z.nativeEnum(CouponType).optional(),
  isBaseCoupon: z.boolean().optional(),
});

// ─── Body Validation for Syncing Base Coupons ─────────────────────────────────
export const syncBaseCouponsSchema = z.object({
  couponIds: z.array(z.string().uuid()),
});

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseCouponResponseSchema = z.object({
  id: z.string().uuid(),
  sellerId: z.string().uuid(),
  discountPct: z.number(),
  adminCommissionPct: z.number(),
  minSpend: z.number().nullable(),
  maxUsesPerBook: z.number(),
  type: z.nativeEnum(CouponType),
  isBaseCoupon: z.boolean(),
  status: z.enum(['ACTIVE', 'INACTIVE']),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export const couponWithSellerResponseSchema = baseCouponResponseSchema.extend({
  seller: z.object({
    businessName: z.string(),
    city: z.object({
      name: z.string(),
    }).optional(),
  }).optional(),
});

export const paginatedCouponsResponseSchema = z.object({
  data: z.array(couponWithSellerResponseSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export type BaseCouponResponse = z.infer<typeof baseCouponResponseSchema>;
export type CouponWithSellerResponse = z.infer<typeof couponWithSellerResponseSchema>;
export type PaginatedCouponsResponse = z.infer<typeof paginatedCouponsResponseSchema>;

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type AdminCouponsQueryDto = z.infer<typeof adminCouponsQuerySchema>;
export type CreateCouponDto = z.infer<typeof createCouponSchema>;
export type UpdateCouponDto = z.infer<typeof updateCouponSchema>;
export type SyncBaseCouponsDto = z.infer<typeof syncBaseCouponsSchema>;
