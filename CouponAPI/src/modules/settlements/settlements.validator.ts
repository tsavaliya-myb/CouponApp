import { z } from 'zod';
import { PAGINATION } from '../../shared/constants';

// ─── List Settlements Query Validation ────────────────────────────────────────
export const settlementsQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
});

export type SettlementsQueryDto = z.infer<typeof settlementsQuerySchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseSettlementSchema = z.object({
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

export const settlementDetailSchema = baseSettlementSchema.extend({
  settlementLines: z.array(z.object({
    id: z.string().uuid(),
    settlementId: z.string().uuid(),
    redemptionId: z.string().uuid(),
    billAmount: z.number(),
    commissionAmt: z.number(),
    coinCompAmt: z.number(),
    createdAt: z.date().or(z.string()),
    redemption: z.object({
      id: z.string().uuid(),
      finalAmount: z.number(),
      userCoupon: z.object({
        coupon: z.object({
          type: z.enum(['STANDARD', 'BOGO']),
          discountPct: z.number(),
        })
      })
    })
  })),
});

export const paginatedSettlementsSchema = z.object({
  data: z.array(baseSettlementSchema),
  meta: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  }),
});

export type BaseSettlementResponse = z.infer<typeof baseSettlementSchema>;
export type SettlementDetailResponse = z.infer<typeof settlementDetailSchema>;
export type PaginatedSettlementsResponse = z.infer<typeof paginatedSettlementsSchema>;
