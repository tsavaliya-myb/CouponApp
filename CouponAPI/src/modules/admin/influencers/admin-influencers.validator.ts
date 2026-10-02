import { z } from 'zod';
import { InfluencerStatus, InfluencerPlatform } from '@prisma/client';
import { PAGINATION } from '../../../shared/constants';

export const adminInfluencersQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  status: z.nativeEnum(InfluencerStatus).optional(),
  nicheId: z.string().uuid().optional(),
  cityId: z.string().uuid().optional(),
  search: z.string().optional(),
});

export const adminUpdateInfluencerSchema = z.object({
  fullName: z.string().optional(),
  displayName: z.string().optional(),
  email: z.string().email().optional().nullable(),
  bio: z.string().optional().nullable(),
  totalFollowers: z.number().int().min(0).optional(),
  engagementRate: z.number().min(0).max(100).optional().nullable(),
  commissionPct: z.number().min(0).max(100).optional(),
});

export const adminBookingsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  influencerId: z.string().uuid().optional(),
  status: z.string().optional(),
});
