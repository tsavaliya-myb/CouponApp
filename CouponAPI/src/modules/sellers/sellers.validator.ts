import { z } from 'zod';
import { SellerStatus } from '@prisma/client';
import { PAGINATION } from '../../shared/constants';

// ─── Seller Registration ──────────────────────────────────────────────────────
export const registerSellerSchema = z.object({
  businessName: z.string().min(2, 'Business name is required').max(150),
  categoryId: z.string().uuid('Invalid Category ID'),
  cityId: z.string().uuid('Invalid City ID'),
  areaId: z.string().uuid('Invalid Area ID'),
  address: z.string().min(5, 'Address is required'),
  email: z.string().email('Invalid email address'),
  upiId: z.string().min(3, 'UPI ID is required').max(100),
  lat: z.number().min(-90).max(90),
  lng: z.number().min(-180).max(180),
});

// ─── Seller Profile Update ────────────────────────────────────────────────────
export const updateSellerSchema = z.object({
  businessName: z.string().min(2).max(150).optional(),
  categoryId: z.string().uuid('Invalid Category ID').optional(),
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

export const getSellersByCityCategorySchema = z.object({
  cityId: z.string().uuid(),
  categoryId: z.string().uuid().optional(),
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(500).default(PAGINATION.DEFAULT_LIMIT),
});

export const getSellerMediaSchema = z.object({
  sellerId: z.string().uuid('Invalid Seller ID'),
});

// ─── Presign / Confirm Schemas ────────────────────────────────────────────────
const IMAGE_MIME = z.enum(['image/jpeg', 'image/jpg', 'image/png']);
const VIDEO_MIME = z.enum(['video/mp4', 'video/quicktime']);

export const presignLogoSchema = z.object({
  mimeType: IMAGE_MIME,
});

export const confirmLogoSchema = z.object({
  fileKey: z.string().min(1),
});

export const presignMediaSchema = z.object({
  photo1MimeType: IMAGE_MIME.optional(),
  photo2MimeType: IMAGE_MIME.optional(),
  videoMimeType: VIDEO_MIME.optional(),
}).refine(
  (d) => d.photo1MimeType || d.photo2MimeType || d.videoMimeType,
  { message: 'At least one of photo1MimeType, photo2MimeType, or videoMimeType is required' },
);

export const confirmMediaSchema = z.object({
  photo1Key: z.string().optional(),
  photo2Key: z.string().optional(),
  videoKey: z.string().optional(),
}).refine(
  (d) => d.photo1Key || d.photo2Key || d.videoKey,
  { message: 'At least one of photo1Key, photo2Key, or videoKey is required' },
);

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type RegisterSellerDto = z.infer<typeof registerSellerSchema>;
export type UpdateSellerDto = z.infer<typeof updateSellerSchema>;
export type FindSellersDto = z.infer<typeof findSellersSchema>;
export type GetSellersByCityCategoryDto = z.infer<typeof getSellersByCityCategorySchema>;

export type GetSellerMediaDto = z.infer<typeof getSellerMediaSchema>;
export type PresignLogoDto = z.infer<typeof presignLogoSchema>;
export type ConfirmLogoDto = z.infer<typeof confirmLogoSchema>;
export type PresignMediaDto = z.infer<typeof presignMediaSchema>;
export type ConfirmMediaDto = z.infer<typeof confirmMediaSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

const categoryShapeSchema = z.object({ id: z.string().uuid(), name: z.string(), slug: z.string(), iconName: z.string().nullable() });

export const baseSellerResponseSchema = z.object({
  id: z.string().uuid(),
  phone: z.string(),
  businessName: z.string(),
  categoryId: z.string().uuid(),
  category: categoryShapeSchema.optional(),
  cityId: z.string().uuid(),
  areaId: z.string().uuid(),
  status: z.nativeEnum(SellerStatus),
  address: z.string().nullable().optional(),
  email: z.string().nullable().optional(),
  upiId: z.string().nullable().optional(),
  lat: z.number().nullable().optional(),
  lng: z.number().nullable().optional(),
});

export const profileResponseSchema = baseSellerResponseSchema.extend({
  city: z.object({ id: z.string(), name: z.string() }).nullable().optional(),
  area: z.object({ id: z.string(), name: z.string() }).nullable().optional(),
  media: z.object({
    logoUrl: z.string().nullable().optional(),
    photoUrl1: z.string().nullable().optional(),
    photoUrl2: z.string().nullable().optional(),
    videoUrl: z.string().nullable().optional(),
  }).nullable().optional(),
});

export const distanceSellerResponseSchema = z.object({
  id: z.string().uuid(),
  businessName: z.string(),
  category: categoryShapeSchema.nullable().optional(),
  area: z.string().nullable().optional(),
  lat: z.number().nullable().optional(),
  lng: z.number().nullable().optional(),
  logoUrl: z.string().nullable().optional(),
  media: z.object({
    logoUrl: z.string().nullable().optional(),
    photoUrl1: z.string().nullable().optional(),
    photoUrl2: z.string().nullable().optional(),
    videoUrl: z.string().nullable().optional(),
  }).nullable().optional(),
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
  todaysRedemptions: z.number(),
  thisWeekRedemptions: z.number(),
  commissionOwed: z.number(),
  coinReceivable: z.number(),
  recentRedemptions: z.array(z.object({
    id: z.string().uuid(),
    couponName: z.string(),
    amount: z.number(),
    createdAt: z.union([z.date(), z.string()]),
  })),
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
