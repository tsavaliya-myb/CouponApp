import { z } from 'zod';
import { SellerCategory, SellerStatus } from '@prisma/client';
import { PAGINATION } from '../../../shared/constants';

// ─── Query Params Validation for Admin Sellers List ───────────────────────────
export const adminSellersQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  cityId: z.string().uuid().optional(),
  areaId: z.string().uuid().optional(),
  category: z.nativeEnum(SellerCategory).optional(),
  status: z.nativeEnum(SellerStatus).optional(),
  search: z.string().optional(),
});

// ─── Body Validation for Admin Seller Edit ────────────────────────────────────
export const adminUpdateSellerSchema = z.object({
  businessName: z.string().min(2).max(150).optional(),
  category: z.nativeEnum(SellerCategory).optional(),
  cityId: z.string().uuid().optional(),
  areaId: z.string().uuid().optional(),
  upiId: z.string().max(100).optional(),
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
  commissionPct: z.number().min(0).max(100).optional(), // Admin specific override
});

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseSellerResponseSchema = z.object({
  id: z.string().uuid(),
  businessName: z.string(),
  phone: z.string(),
  email: z.string().nullable(),
  category: z.nativeEnum(SellerCategory),
  cityId: z.string().uuid(),
  areaId: z.string().uuid(),
  address: z.string().nullable(),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  upiId: z.string().nullable(),
  operatingHours: z.string().nullable(),
  commissionPct: z.number(),
  status: z.nativeEnum(SellerStatus),
  onesignalPlayerId: z.string().nullable(),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export const sellerWithLocationResponseSchema = baseSellerResponseSchema.extend({
  city: z.object({ name: z.string() }).optional(),
  area: z.object({ name: z.string() }).optional(),
});

export const paginatedSellersResponseSchema = z.object({
  data: z.array(sellerWithLocationResponseSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export type BaseSellerResponse = z.infer<typeof baseSellerResponseSchema>;
export type SellerWithLocationResponse = z.infer<typeof sellerWithLocationResponseSchema>;
export type PaginatedSellersResponse = z.infer<typeof paginatedSellersResponseSchema>;

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type AdminSellersQueryDto = z.infer<typeof adminSellersQuerySchema>;
export type AdminUpdateSellerDto = z.infer<typeof adminUpdateSellerSchema>;
