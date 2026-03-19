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
