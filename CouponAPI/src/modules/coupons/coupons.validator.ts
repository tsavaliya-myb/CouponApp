import { z } from 'zod';
import { SellerCategory } from '@prisma/client';
import { PAGINATION } from '../../shared/constants';

// ─── Query for My Active Coupons (UserCoupons) ────────────────────────────────
export const myCouponsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  category: z.nativeEnum(SellerCategory).optional(), // Filter by seller category
  sellerId: z.string().uuid().optional(),            // Filter by specific seller
});

// ─── Query for Seller's Master Coupons ────────────────────────────────────────
export const sellerCouponsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type MyCouponsQueryDto = z.infer<typeof myCouponsQuerySchema>;
export type SellerCouponsQueryDto = z.infer<typeof sellerCouponsQuerySchema>;
