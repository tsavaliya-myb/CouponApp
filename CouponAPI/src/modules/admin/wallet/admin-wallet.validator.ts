import { z } from 'zod';

// ─── AppSettings Update ───────────────────────────────────────────────────────
export const updateWalletSettingsSchema = z.object({
  coinsPerSubscription: z.number().int().min(0).optional(),
  maxCoinsPerTransaction: z.number().int().min(0).optional(),
});

// ─── Bulk Award Coins ─────────────────────────────────────────────────────────
export const bulkAwardCoinsSchema = z.object({
  amount: z.number().int().positive(),
  cityId: z.string().uuid().optional(),
  note: z.string().optional().default('Promotional award from administration'),
});

export type UpdateWalletSettingsDto = z.infer<typeof updateWalletSettingsSchema>;
export type BulkAwardCoinsDto = z.infer<typeof bulkAwardCoinsSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const walletSettingsResponseSchema = z.object({
  coinsPerSubscription: z.number(),
  maxCoinsPerTransaction: z.number(),
});

export const walletOverviewResponseSchema = z.object({
  totalIssued: z.number(),
  totalUsed: z.number(),
  outstandingLiability: z.number(),
});

export const bulkAwardResponseSchema = z.object({
  awardedCount: z.number(),
  totalCoins: z.number(),
});

export type WalletSettingsResponse = z.infer<typeof walletSettingsResponseSchema>;
export type WalletOverviewResponse = z.infer<typeof walletOverviewResponseSchema>;
export type BulkAwardResponse = z.infer<typeof bulkAwardResponseSchema>;
