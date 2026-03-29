import { z } from 'zod';
import { SellerCategory, SellerStatus } from '@prisma/client';
import { PAGINATION } from '../../shared/constants';

// ─── Seller Registration ──────────────────────────────────────────────────────
export const registerSellerSchema = z.object({
  businessName: z.string().min(2, 'Business name is required').max(150),
  category: z.nativeEnum(SellerCategory).optional(),
  cityId: z.string().uuid('Invalid City ID'),
  areaId: z.string().uuid('Invalid Area ID'),
  upiId: z.string().max(100).optional(),
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
});

// ─── Seller Profile Update ────────────────────────────────────────────────────
export const updateSellerSchema = z.object({
  businessName: z.string().min(2).max(150).optional(),
  category: z.nativeEnum(SellerCategory).optional(),
  cityId: z.string().uuid().optional(),
  areaId: z.string().uuid().optional(),
  upiId: z.string().max(100).optional(),
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
});

// ─── Customer View: Find Sellers API ──────────────────────────────────────────
export const findSellersSchema = z.object({
  lat: z.coerce.number().min(-90).max(90),
  lng: z.coerce.number().min(-180).max(180),
  cityId: z.string().uuid().optional(), // Optionally restrict to a specific city
  search: z.string().optional(),
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
});

export const getSellersByAreaCategorySchema = z.object({
  areaId: z.string().uuid(),
  categoryType: z.nativeEnum(SellerCategory).optional(),
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type RegisterSellerDto = z.infer<typeof registerSellerSchema>;
export type UpdateSellerDto = z.infer<typeof updateSellerSchema>;
export type FindSellersDto = z.infer<typeof findSellersSchema>;
export type GetSellersByAreaCategoryDto = z.infer<typeof getSellersByAreaCategorySchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseSellerResponseSchema = z.object({
  id: z.string().uuid(),
  phone: z.string(),
  businessName: z.string(),
  category: z.nativeEnum(SellerCategory),
  cityId: z.string().uuid(),
  areaId: z.string().uuid(),
  status: z.nativeEnum(SellerStatus),
});

export const profileResponseSchema = baseSellerResponseSchema.extend({
  city: z.object({ id: z.string(), name: z.string() }).nullable().optional(),
  area: z.object({ id: z.string(), name: z.string() }).nullable().optional(),
});

export const distanceSellerResponseSchema = z.object({
  id: z.string().uuid(),
  businessName: z.string(),
  category: z.nativeEnum(SellerCategory),
  area: z.string().nullable().optional(),
  lat: z.number().nullable().optional(),
  lng: z.number().nullable().optional(),
  distanceKm: z.number().nullable().optional(),
});

export const loginSellerResponseSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  seller: baseSellerResponseSchema,
  message: z.string(),
});

export const sellerDashboardResponseSchema = z.object({
  totalRedemptions: z.number(),
  status: z.nativeEnum(SellerStatus),
  commissionPct: z.number(),
});

export const paginatedDistanceSellersResponseSchema = z.object({
  data: z.array(distanceSellerResponseSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export type BaseSellerResponse = z.infer<typeof baseSellerResponseSchema>;
export type ProfileResponse = z.infer<typeof profileResponseSchema>;
export type DistanceSellerResponse = z.infer<typeof distanceSellerResponseSchema>;
export type LoginSellerResponse = z.infer<typeof loginSellerResponseSchema>;
export type SellerDashboardResponse = z.infer<typeof sellerDashboardResponseSchema>;
export type PaginatedDistanceSellersResponse = z.infer<typeof paginatedDistanceSellersResponseSchema>;
