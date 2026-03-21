import { prisma } from '../../config/db';
import { RedisCacheService } from '../../shared/services/redisCache.service';
import { REDIS_KEYS } from '../../shared/constants';
import type { 
  AnalyticsSubscriptionsQuery, 
  AnalyticsRedemptionsQuery, 
  AnalyticsGenericLimitQuery,
  SubscriptionStatsResponse,
  RedemptionStatsResponse,
  TopSellerStatsResponse,
  TopCouponStatsResponse,
  CoinStatsResponse,
  ChurnStatsResponse,
  RevenueStatsResponse,
  RedemptionByCategoryResponse,
  AnalyticsRevenueQuery,
} from './analytics.validator';
import { appSettingsService } from '../admin/settings/settings.service';
import { startOfWeek, startOfMonth, startOfYear, eachDayOfInterval, eachWeekOfInterval, eachMonthOfInterval, endOfWeek, endOfMonth, endOfYear, format } from 'date-fns';

export class AnalyticsService {
  
  private async withCache<T>(paramKey: string, fn: () => Promise<T>): Promise<T> {
    const cacheKey = REDIS_KEYS.ANALYTICS(paramKey);
    const cached = await RedisCacheService.getCache<T>(cacheKey);
    if (cached) return cached;
    const data = await fn();
    await RedisCacheService.setCache(cacheKey, data, 30 * 60); // 30-minute TTL
    return data;
  }

  // ─── Subscriptions & Revenue ──────────────────────────────────────────────────
  async getSubscriptionsStats(query: AnalyticsSubscriptionsQuery): Promise<SubscriptionStatsResponse> {
    return this.withCache(`subscriptions:${JSON.stringify(query)}`, async () => {
      const { startDate, endDate, cityId, groupBy } = query;
      
      const where: any = {};
      if (startDate || endDate) {
        where.createdAt = {};
        if (startDate) where.createdAt.gte = new Date(startDate);
        if (endDate) where.createdAt.lte = new Date(endDate);
      }
      if (cityId) where.user = { cityId };

      const totalCount = await prisma.subscription.count({ where });

      return {
        totalCount,
        totalRevenue: 0,
      };
    });
  }

  // ─── Redemptions ──────────────────────────────────────────────────────────────
  async getRedemptionsStats(query: AnalyticsRedemptionsQuery): Promise<RedemptionStatsResponse> {
    return this.withCache(`redemptions:${JSON.stringify(query)}`, async () => {
      const { startDate, endDate, cityId, categoryId, sellerId } = query;
      
      const where: any = {};
      if (startDate || endDate) {
        where.createdAt = {};
        if (startDate) where.createdAt.gte = new Date(startDate);
        if (endDate) where.createdAt.lte = new Date(endDate);
      }
      if (sellerId) where.sellerId = sellerId;
      if (categoryId) where.seller = { ...where.seller, categoryId };
      if (cityId) where.user = { cityId };

      const totalCount = await prisma.redemption.count({ where });

      return { totalRedemptions: totalCount };
    });
  }

  // ─── Top 10 Sellers (by Redemption Count) ─────────────────────────────────────
  async getTopSellers(query: AnalyticsGenericLimitQuery): Promise<TopSellerStatsResponse[]> {
    return this.withCache(`top_sellers:${JSON.stringify(query)}`, async () => {
      const { limit, startDate, endDate } = query;
      const where: any = startDate || endDate ? { redeemedAt: { ...(startDate && { gte: new Date(startDate) }), ...(endDate && { lte: new Date(endDate) }) } } : {};

      const agg = await prisma.redemption.groupBy({
        by: ['sellerId'],
        where,
        _count: { _all: true },
        orderBy: { _count: { sellerId: 'desc' } },
        take: limit,
      });

      // Populate seller names
      const sellerIds = agg.map(a => a.sellerId).filter(Boolean) as string[];
      const sellers = await prisma.seller.findMany({ where: { id: { in: sellerIds } }, select: { id: true, businessName: true } });

      return agg.map(row => ({
        sellerId: row.sellerId,
        businessName: sellers.find(s => s.id === row.sellerId)?.businessName || 'Unknown',
        redemptions: row._count._all,
      }));
    });
  }

  // ─── Top 10 Coupons ───────────────────────────────────────────────────────────
  async getTopCoupons(query: AnalyticsGenericLimitQuery): Promise<TopCouponStatsResponse[]> {
    return this.withCache(`top_coupons:${JSON.stringify(query)}`, async () => {
      const { limit, startDate, endDate } = query;
      const where: any = startDate || endDate ? { redeemedAt: { ...(startDate && { gte: new Date(startDate) }), ...(endDate && { lte: new Date(endDate) }) } } : {};

      const agg = await prisma.redemption.groupBy({
        by: ['userCouponId'],
        where,
        _count: { _all: true },
        orderBy: { _count: { userCouponId: 'desc' } },
        take: limit,
      });

      const userCouponIds = agg.map(a => a.userCouponId).filter(Boolean) as string[];
      const userCoupons = await prisma.userCoupon.findMany({
        where: { id: { in: userCouponIds } },
        include: { coupon: { select: { discountPct: true, type: true } } }
      });

      return agg.map(row => {
        const uc = userCoupons.find(c => c.id === row.userCouponId);
        return {
          userCouponId: row.userCouponId,
          title: uc ? `Coupon (${uc.coupon.discountPct}% OFF)` : 'Unknown',
          type: uc?.coupon?.type,
          redemptions: row._count._all,
        };
      });
    });
  }

  // ─── Coin Economy ─────────────────────────────────────────────────────────────
  async getCoinStats(): Promise<CoinStatsResponse> {
    return this.withCache(`coin_stats:all`, async () => {
      const agg = await prisma.walletTransaction.groupBy({
        by: ['type'],
        _sum: { amount: true },
        _count: { id: true },
      });

      const earned = agg.find(x => x.type === 'EARNED');
      const used = agg.find(x => x.type === 'USED');

      return {
        totalAwarded: earned?._sum.amount || 0,
        awardedTxCount: earned?._count.id || 0,
        totalUsed: used?._sum.amount || 0,
        usedTxCount: used?._count.id || 0,
      };
    });
  }

  // ─── Churn Rate ───────────────────────────────────────────────────────────────
  async getChurnStats(): Promise<ChurnStatsResponse> {
    return this.withCache(`churn_stats:all`, async () => {
      const now = new Date();
      
      const activeSubs = await prisma.subscription.count({
        where: { status: 'ACTIVE', endDate: { gt: now } }
      });
      
      const expiredSubs = await prisma.subscription.count({
        where: { OR: [ { status: 'EXPIRED' }, { endDate: { lt: now } } ] }
      });

      return {
        activeSubscriptions: activeSubs,
        expiredSubscriptions: expiredSubs,
      };
    });
  }

  // ─── Revenue Analytics ────────────────────────────────────────────────────────
  async getRevenueStats(query: AnalyticsRevenueQuery): Promise<RevenueStatsResponse> {
    const { groupBy } = query;
    return this.withCache(`revenue_stats:${groupBy}`, async () => {
      const now = new Date();
      const subPrice = parseInt(await appSettingsService.getSetting('subscription_price', '500')) || 500;

      const fetchPeriodData = async (startDate: Date, endDate: Date, label: string) => {
        const subsCount = await prisma.subscription.count({
          where: { createdAt: { gte: startDate, lte: endDate } }
        });
        const subscriptionRevenue = subsCount * subPrice;

        const settlements = await prisma.settlementLine.aggregate({
          where: { createdAt: { gte: startDate, lte: endDate } },
          _sum: { commissionAmt: true }
        });
        const commissionRevenue = settlements._sum.commissionAmt || 0;

        return {
          label,
          subscriptionRevenue,
          commissionRevenue,
          totalRevenue: subscriptionRevenue + commissionRevenue
        };
      };

      let intervals: { start: Date; end: Date; label: string }[] = [];

      if (groupBy === 'day') {
        const startOfCurrentWeek = startOfWeek(now, { weekStartsOn: 1 });
        const endOfCurrentWeek = endOfWeek(now, { weekStartsOn: 1 });
        const days = eachDayOfInterval({ start: startOfCurrentWeek, end: endOfCurrentWeek });
        intervals = days.map(d => ({
          start: d,
          end: new Date(d.getFullYear(), d.getMonth(), d.getDate(), 23, 59, 59, 999),
          label: format(d, 'EEEE')
        }));
      } else if (groupBy === 'week') {
        const startOfCurrentMonth = startOfMonth(now);
        const endOfCurrentMonth = endOfMonth(now);
        const weeks = eachWeekOfInterval({ start: startOfCurrentMonth, end: endOfCurrentMonth }, { weekStartsOn: 1 });
        intervals = weeks.map((w, index) => {
          const wEnd = endOfWeek(w, { weekStartsOn: 1 });
          return {
            start: w < startOfCurrentMonth ? startOfCurrentMonth : w,
            end: wEnd > endOfCurrentMonth ? endOfCurrentMonth : wEnd,
            label: `Week ${index + 1}`
          };
        });
      } else if (groupBy === 'year') {
        const startOfCurrentYear = startOfYear(now);
        const endOfCurrentYear = endOfYear(now);
        const months = eachMonthOfInterval({ start: startOfCurrentYear, end: endOfCurrentYear });
        intervals = months.map(m => ({
          start: m,
          end: endOfMonth(m),
          label: format(m, 'MMM')
        }));
      }

      const results = await Promise.all(intervals.map(i => fetchPeriodData(i.start, i.end, i.label)));
      return results;
    });
  }

  // ─── Redemptions by Category ──────────────────────────────────────────────────
  async getRedemptionsByCategory(query: { startDate?: string; endDate?: string }): Promise<RedemptionByCategoryResponse> {
    return this.withCache(`redemptions_category:${JSON.stringify(query)}`, async () => {
      const { startDate, endDate } = query;
      
      const redemptionCondition: any = {};
      if (startDate || endDate) {
        redemptionCondition.redeemedAt = {};
        if (startDate) redemptionCondition.redeemedAt.gte = new Date(startDate);
        if (endDate) redemptionCondition.redeemedAt.lte = new Date(endDate);
      }

      const sellers = await prisma.seller.findMany({
        select: {
          category: true,
          _count: {
            select: {
              redemptions: Object.keys(redemptionCondition).length > 0 ? { where: redemptionCondition } : true
            }
          }
        }
      });

      const categoryCounts: Record<string, number> = {};
      for (const seller of sellers) {
        categoryCounts[seller.category] = (categoryCounts[seller.category] || 0) + seller._count.redemptions;
      }

      return Object.entries(categoryCounts)
        .map(([category, redemptions]) => ({ category, redemptions }))
        .sort((a, b) => b.redemptions - a.redemptions);
    });
  }
}
