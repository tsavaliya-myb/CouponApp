import { z } from 'zod';

export const adminDashboardStatsResponseSchema = z.object({
  activeSubscribers: z.number(),
  revenueThisMonth: z.number(),
  redemptions: z.object({
    today: z.number(),
    thisWeek: z.number(),
  }),
  pendingSettlements: z.number(),
  pendingSellers: z.number(),
  coins: z.object({
    awardedThisMonth: z.number(),
    pendingCompensation: z.number(),
  }),
});

export type AdminDashboardStatsResponse = z.infer<typeof adminDashboardStatsResponseSchema>;
