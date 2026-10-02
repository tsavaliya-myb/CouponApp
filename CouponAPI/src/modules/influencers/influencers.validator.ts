import { z } from 'zod';
import { InfluencerPlatform, BookingStatus, CouponStatus } from '@prisma/client';
import { PAGINATION } from '../../shared/constants';

// ─── Registration ─────────────────────────────────────────────────────────────

export const registerInfluencerSchema = z.object({
  fullName: z.string().min(2).max(150),
  displayName: z.string().min(2).max(100),
  nicheId: z.string().uuid(),
  cityId: z.string().uuid(),
  email: z.string().email().optional().nullable(),
  bio: z.string().max(300).optional().nullable(),
  totalFollowers: z.number().int().min(0).default(0),
  upiId: z.string().min(3).max(100).optional().nullable(),
  platforms: z.array(z.nativeEnum(InfluencerPlatform)).optional(),
  socialLinks: z.record(z.string(), z.string().url()).optional(),
});

// ─── Update Profile ───────────────────────────────────────────────────────────

export const updateInfluencerSchema = registerInfluencerSchema.partial();

// ─── Customer: Find Influencers ───────────────────────────────────────────────

export const findInfluencersSchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  nicheId: z.string().uuid().optional(),
  cityId: z.string().uuid().optional(),
  platform: z.nativeEnum(InfluencerPlatform).optional(),
  followerTier: z.enum(['nano', 'micro', 'macro', 'mega']).optional(),
  search: z.string().optional(),
  sortBy: z.enum(['followers', 'newest', 'bookings']).optional().default('newest'),
});

// ─── Service Packages (Influencer Side) ───────────────────────────────────────

export const createServiceSchema = z.object({
  name: z.string().min(2).max(100),
  description: z.string().max(1000).optional().nullable(),
  price: z.number().min(0),
  discountedPrice: z.number().min(0).optional().nullable(),
  deliveryDays: z.number().int().min(1).default(3),
  status: z.nativeEnum(CouponStatus).optional().default('ACTIVE'),
});

export const updateServiceSchema = createServiceSchema.partial();

// ─── Bookings (Customer books a service) ──────────────────────────────────────

export const createBookingSchema = z.object({
  serviceId: z.string().uuid(),
  coinsToUse: z.number().int().min(0).default(0),
  userNote: z.string().max(500).optional().nullable(),
});

// ─── Bookings (Influencer updates status) ─────────────────────────────────────

export const updateBookingStatusSchema = z.object({
  status: z.enum(['ACCEPTED', 'IN_PROGRESS', 'DELIVERED', 'CANCELLED']),
  deliveryNote: z.string().max(1000).optional().nullable(),
});

// ─── Media Upload ─────────────────────────────────────────────────────────────

export const presignMediaSchema = z.object({
  fileType: z.string(), // e.g. "image/jpeg"
});

export const confirmMediaSchema = z.object({
  fileKey: z.string(),
});

// ─── Types ────────────────────────────────────────────────────────────────────

export type RegisterInfluencerDto = z.infer<typeof registerInfluencerSchema>;
export type UpdateInfluencerDto = z.infer<typeof updateInfluencerSchema>;
export type FindInfluencersQueryDto = z.infer<typeof findInfluencersSchema>;
export type CreateServiceDto = z.infer<typeof createServiceSchema>;
export type UpdateServiceDto = z.infer<typeof updateServiceSchema>;
export type CreateBookingDto = z.infer<typeof createBookingSchema>;
export type UpdateBookingStatusDto = z.infer<typeof updateBookingStatusSchema>;
