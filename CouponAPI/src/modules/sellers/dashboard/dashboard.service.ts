import { prisma } from '../../../config/db';
import { startOfDay, startOfWeek } from 'date-fns';
import { redis } from '../../../config/redis';
import { REDIS_PREFIX, REDIS_KEYS } from '../../../shared/constants';

export class SellerDashboardService {
  async getDashboardStats(sellerId: string) {
    const now = new Date();
    const today = startOfDay(now);
    const wStart = startOfWeek(now, { weekStartsOn: 1 });

    // 1. Redemptions (Today & This Week)
    
    // Attempt to load today's redemptions from Redis fast-path
    const redisRedemptionsTodayKey = REDIS_KEYS.SELLER_REDEMPTIONS_TODAY(sellerId);
    let redemptionsToday = 0;
    
    const cachedToday = await redis.get(redisRedemptionsTodayKey);
    if (cachedToday !== null) {
      redemptionsToday = parseInt(cachedToday, 10);
    } else {
      // Fallback to DB if cache is missing
      redemptionsToday = await prisma.redemption.count({
        where: { sellerId, redeemedAt: { gte: today } }
      });
      // Optionally re-seed the cache (expire at midnight handled in write-path typically, but we can do simple EX here)
      const secondsUntilMidnight = Math.max(0, Math.floor((new Date(today.getTime() + 24 * 60 * 60 * 1000).getTime() - Date.now()) / 1000));
      await redis.set(redisRedemptionsTodayKey, redemptionsToday, 'EX', secondsUntilMidnight);
    }

    const redemptionsThisWeek = await prisma.redemption.count({
      where: { sellerId, redeemedAt: { gte: wStart } }
    });

    // 2. Financials (Owed Commissions & Receivable Coins this week)
    const currentSettlement = await prisma.settlement.findUnique({
      where: { sellerId_weekStart: { sellerId, weekStart: wStart } }
    });

    return {
      redemptions: {
        today: redemptionsToday,
        thisWeek: redemptionsThisWeek,
      },
      financialsThisWeek: {
        commissionOwedToAdmin: currentSettlement?.commissionTotal || 0,
        coinCompensationReceivableFromAdmin: currentSettlement?.coinCompensationTotal || 0,
        status: currentSettlement?.commissionStatus || 'PENDING'
      }
    };
  }
}

export const sellerDashboardService = new SellerDashboardService();
