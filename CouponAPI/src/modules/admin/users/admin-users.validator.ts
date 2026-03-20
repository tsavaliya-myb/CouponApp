import { z } from 'zod';
import { PAGINATION } from '../../../shared/constants';

// ─── Query Params Validation for Admin Users List ──────────────────────────────
export const adminUsersQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  cityId: z.string().uuid().optional(),
  areaId: z.string().uuid().optional(),
  status: z.enum(['ACTIVE', 'BLOCKED']).optional(),
  search: z.string().optional(),
});

// ─── Body Validation: Award Coins ─────────────────────────────────────────────
export const awardCoinsSchema = z.object({
  amount: z.number().int().positive('Amount must be a positive integer'),
  note: z.string().max(255).optional(),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type AdminUsersQueryDto = z.infer<typeof adminUsersQuerySchema>;
export type AwardCoinsDto = z.infer<typeof awardCoinsSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseUserResponseSchema = z.object({
  id: z.string().uuid(),
  phone: z.string(),
  name: z.string().nullable(),
  email: z.string().nullable(),
  cityId: z.string().uuid().nullable(),
  areaId: z.string().uuid().nullable(),
  status: z.enum(['ACTIVE', 'BLOCKED']),
  onesignalPlayerId: z.string().nullable(),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export const userWithLocationResponseSchema = baseUserResponseSchema.extend({
  city: z.object({ name: z.string() }).nullable().optional(),
  area: z.object({ name: z.string() }).nullable().optional(),
});

export const paginatedUsersResponseSchema = z.object({
  data: z.array(userWithLocationResponseSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

// Since getUserDetails returns a deep tree, we will use z.any() wrapped or a partial schema for brevity, but let's define a specific schema that extends base user with relations
export const userDetailsResponseSchema = baseUserResponseSchema.extend({
  city: z.object({ name: z.string() }).nullable().optional(),
  area: z.object({ name: z.string() }).nullable().optional(),
  subscription: z.any().nullable().optional(),
  wallet: z.array(z.any()).optional(),
  redemptions: z.array(z.any()).optional(),
});

export const awardCoinsResponseSchema = z.object({
  message: z.string(),
  transaction: z.any(),
});

export type BaseUserResponse = z.infer<typeof baseUserResponseSchema>;
export type UserWithLocationResponse = z.infer<typeof userWithLocationResponseSchema>;
export type PaginatedUsersResponse = z.infer<typeof paginatedUsersResponseSchema>;
export type UserDetailsResponse = z.infer<typeof userDetailsResponseSchema>;
export type AwardCoinsResponse = z.infer<typeof awardCoinsResponseSchema>;
