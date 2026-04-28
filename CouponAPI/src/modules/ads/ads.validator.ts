import { z } from 'zod';

// ─── Shared enum ──────────────────────────────────────────────────────────────
export const bannerAdStatuses = ['ACTIVE', 'PAUSED', 'COMPLETED'] as const;

// ─── Admin: Create a new banner ad ───────────────────────────────────────────
export const createBannerAdSchema = z.object({
  title:     z.string().min(3).max(100),
  // Optional: associate with a seller (for display / reporting)
  sellerId:  z.string().uuid().optional(),
  // At least one of image or video must be provided
  imageUrl:  z.string().url().optional(),
  videoUrl:  z.string().url().optional(),
  // Optional deep-link destination
  actionUrl: z.string().url().optional(),
  // One or more city IDs to target (empty = show in all cities)
  cityIds:   z.array(z.string().uuid()).min(1, 'Select at least one city'),
  // Campaign window
  startsAt:  z.string().datetime('startsAt must be an ISO datetime'),
  endsAt:    z.string().datetime('endsAt must be an ISO datetime'),
}).refine(
  (d) => d.imageUrl || d.videoUrl,
  { message: 'Provide at least one of imageUrl or videoUrl' }
).refine(
  (d) => new Date(d.endsAt) > new Date(d.startsAt),
  { message: 'endsAt must be after startsAt', path: ['endsAt'] }
);

export type CreateBannerAdDto = z.infer<typeof createBannerAdSchema>;

// ─── Admin: Update an existing banner ad ─────────────────────────────────────
export const updateBannerAdSchema = z.object({
  title:     z.string().min(3).max(100).optional(),
  sellerId:  z.string().uuid().nullable().optional(),
  imageUrl:  z.string().url().nullable().optional(),
  videoUrl:  z.string().url().nullable().optional(),
  actionUrl: z.string().url().nullable().optional(),
  cityIds:   z.array(z.string().uuid()).min(1).optional(),
  startsAt:  z.string().datetime().optional(),
  endsAt:    z.string().datetime().optional(),
  status:    z.enum(bannerAdStatuses).optional(),
});

export type UpdateBannerAdDto = z.infer<typeof updateBannerAdSchema>;

// ─── Admin: List query ────────────────────────────────────────────────────────
export const adminListAdsQuerySchema = z.object({
  status:   z.enum(bannerAdStatuses).optional(),
  sellerId: z.string().uuid().optional(),
  cityId:   z.string().uuid().optional(),
  page:     z.coerce.number().int().positive().default(1),
  limit:    z.coerce.number().int().positive().max(100).default(20),
});

export type AdminListAdsDto = z.infer<typeof adminListAdsQuerySchema>;

// ─── Public: Active slider banners query ──────────────────────────────────────
export const publicBannersQuerySchema = z.object({
  // Customer sends their cityId; we return city-targeted + global (no cityIds) ads
  cityId: z.string().uuid().optional(),
});

export type PublicBannersDto = z.infer<typeof publicBannersQuerySchema>;
