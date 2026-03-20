import { z } from 'zod';
import { PAGINATION } from '../../../shared/constants';

// ─── Query for Pending Settlements ────────────────────────────────────────────
export const pendingSettlementsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  sellerId: z.string().uuid().optional(),
});

// ─── Mark Settlement Paid Mutation ────────────────────────────────────────────
export const markPaidSchema = z.object({
  commissionPaid: z.boolean().optional(),
  coinCompPaid: z.boolean().optional(),
});

export type PendingSettlementsQueryDto = z.infer<typeof pendingSettlementsQuerySchema>;
export type MarkPaidDto = z.infer<typeof markPaidSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseSettlementResponseSchema = z.object({
  id: z.string().uuid(),
  sellerId: z.string().uuid(),
  weekStart: z.date().or(z.string()),
  weekEnd: z.date().or(z.string()),
  commissionTotal: z.number(),
  commissionStatus: z.enum(['PENDING', 'PAID']),
  commissionPaidAt: z.date().or(z.string()).nullable(),
  coinCompensationTotal: z.number(),
  coinCompStatus: z.enum(['PENDING', 'PAID']),
  coinCompPaidAt: z.date().or(z.string()).nullable(),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export const settlementWithSellerResponseSchema = baseSettlementResponseSchema.extend({
  seller: z.object({
    businessName: z.string(),
    phone: z.string(),
  }).optional(),
});

export const paginatedSettlementsResponseSchema = z.object({
  data: z.array(settlementWithSellerResponseSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export const exportCsvResponseSchema = z.object({
  jobId: z.string(),
  downloadEndpoint: z.string(),
});

export type BaseSettlementResponse = z.infer<typeof baseSettlementResponseSchema>;
export type SettlementWithSellerResponse = z.infer<typeof settlementWithSellerResponseSchema>;
export type PaginatedSettlementsResponse = z.infer<typeof paginatedSettlementsResponseSchema>;
