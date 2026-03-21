import { prisma } from '../../../config/db';
import { startOfDay, startOfWeek, startOfMonth, startOfYear, subDays, eachDayOfInterval, format, endOfDay } from 'date-fns';
import { appSettingsService } from '../settings/settings.service';
import type { AdminDashboardStatsResponse } from './dashboard.validator';

export class AdminDashboardService {
  async getDashboardStats(): Promise<AdminDashboardStatsResponse> {
    const now = new Date();
    const today = startOfDay(now);
    const thisWeek = startOfWeek(now, { weekStartsOn: 1 });
    const thisMonth = startOfMonth(now);

    // 1. Active Subscribers
    const activeSubscribers = await prisma.subscription.count({
      where: { status: 'ACTIVE' }
    });

    // 2. Revenue This Month (Mocked MVP: Subs this month * Price)
    const subsThisMonth = await prisma.subscription.count({
      where: { createdAt: { gte: thisMonth } }
    });
    const subPrice = parseInt(await appSettingsService.getSetting('subscription_price', '500')) || 500;
    const revenueThisMonth = subsThisMonth * subPrice;

    // 3. Redemptions (Today & This Week)
    const redemptionsToday = await prisma.redemption.count({
      where: { redeemedAt: { gte: today } }
    });
    const redemptionsThisWeek = await prisma.redemption.count({
      where: { redeemedAt: { gte: thisWeek } }
    });

    // 4. Pending Settlements
    const pendingSettlements = await prisma.settlement.count({
      where: { commissionStatus: 'PENDING' }
    });

    // 5. Pending Seller Approvals
    const pendingSellers = await prisma.seller.count({
      where: { status: 'PENDING' }
    });

    // 6. Coins (Awarded this month, Pending Compensation)
    const coinsAwardedThisMonthResult = await prisma.walletTransaction.aggregate({
      where: { type: 'EARNED', createdAt: { gte: thisMonth } },
      _sum: { amount: true }
    });
    const coinsAwardedThisMonth = coinsAwardedThisMonthResult._sum.amount || 0;

    // Pending coin compensation = settlements tracking COIN_COMPENSATION physically
    const pendingCoinCompensationResult = await prisma.settlement.aggregate({
      where: { coinCompStatus: 'PENDING' },
      _sum: { coinCompensationTotal: true }
    });
    const pendingCoinCompensation = pendingCoinCompensationResult._sum.coinCompensationTotal || 0;

    // 7. Last 7 Days Chart Data
    const last7DaysStart = startOfDay(subDays(now, 6)); // 6 days ago + today = 7 days
    const chartIntervals = eachDayOfInterval({ start: last7DaysStart, end: now });
    
    const [recentSubs, recentRedemptions] = await Promise.all([
      prisma.subscription.findMany({
        where: { createdAt: { gte: last7DaysStart } },
        select: { createdAt: true }
      }),
      prisma.redemption.findMany({
        where: { redeemedAt: { gte: last7DaysStart } },
        select: { redeemedAt: true }
      })
    ]);

    const last7Days = chartIntervals.map(day => {
      const dayStart = startOfDay(day);
      const dayEnd = endOfDay(day);
      
      const subsCount = recentSubs.filter(s => s.createdAt >= dayStart && s.createdAt <= dayEnd).length;
      const redemptionsCount = recentRedemptions.filter(r => r.redeemedAt >= dayStart && r.redeemedAt <= dayEnd).length;

      return {
        date: format(day, 'MMM dd'),
        subscriptions: subsCount,
        redemptions: redemptionsCount
      };
    });

    return {
      activeSubscribers,
      revenueThisMonth,
      redemptions: {
        today: redemptionsToday,
        thisWeek: redemptionsThisWeek
      },
      pendingSettlements,
      pendingSellers,
      coins: {
        awardedThisMonth: coinsAwardedThisMonth,
        pendingCompensation: pendingCoinCompensation
      },
      last7Days
    };
  }
}

export const adminDashboardService = new AdminDashboardService();
