import { z } from 'zod';
import { PAGINATION } from '../../shared/constants';

// ─── Query Validation for Wallet History ──────────────────────────────────────
export const walletHistoryQuerySchema = z.object({
  page: z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit: z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
});

export type WalletHistoryQueryDto = z.infer<typeof walletHistoryQuerySchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseWalletTransactionSchema = z.object({
  id: z.string().uuid(),
  userId: z.string().uuid(),
  type: z.enum(['EARNED', 'USED']),
  amount: z.number(),
  redemptionId: z.string().uuid().nullable().optional(),
  note: z.string().nullable().optional(),
  createdAt: z.date().or(z.string()),
});

export const walletHistoryResponseSchema = z.object({
  balance: z.number(),
  transactions: z.object({
    data: z.array(baseWalletTransactionSchema),
    meta: z.object({
      total: z.number(),
      page: z.number(),
      limit: z.number(),
      totalPages: z.number(),
    }),
  }),
});

export type BaseWalletTransactionResponse = z.infer<typeof baseWalletTransactionSchema>;
export type WalletHistoryResponse = z.infer<typeof walletHistoryResponseSchema>;
