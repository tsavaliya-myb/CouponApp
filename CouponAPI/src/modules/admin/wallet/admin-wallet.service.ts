import { prisma } from '../../../config/db';
import type { 
  UpdateWalletSettingsDto, 
  BulkAwardCoinsDto,
  WalletSettingsResponse,
  WalletOverviewResponse,
  BulkAwardResponse,
} from './admin-wallet.validator';

export class AdminWalletService {
  
  // ─── Global Wallet Settings ───────────────────────────────────────────────────
  async getSettings(): Promise<WalletSettingsResponse> {
    const settings = await prisma.appSetting.findMany({
      where: { key: { in: ['COINS_PER_SUBSCRIPTION', 'MAX_COINS_PER_TRANSACTION'] } }
    });

    const getVal = (k: string, d: number) => {
      const s = settings.find(x => x.key === k);
      return s ? parseInt(s.value, 10) : d;
    };

    return {
      coinsPerSubscription: getVal('COINS_PER_SUBSCRIPTION', 100), // example default
      maxCoinsPerTransaction: getVal('MAX_COINS_PER_TRANSACTION', 50),
    };
  }

  async updateSettings(dto: UpdateWalletSettingsDto): Promise<WalletSettingsResponse> {
    const { coinsPerSubscription, maxCoinsPerTransaction } = dto;

    const upserts = [];

    if (coinsPerSubscription !== undefined) {
      upserts.push(
        prisma.appSetting.upsert({
          where: { key: 'COINS_PER_SUBSCRIPTION' },
          update: { value: coinsPerSubscription.toString() },
          create: { key: 'COINS_PER_SUBSCRIPTION', value: coinsPerSubscription.toString() },
        })
      );
    }

    if (maxCoinsPerTransaction !== undefined) {
      upserts.push(
        prisma.appSetting.upsert({
          where: { key: 'MAX_COINS_PER_TRANSACTION' },
          update: { value: maxCoinsPerTransaction.toString() },
          create: { key: 'MAX_COINS_PER_TRANSACTION', value: maxCoinsPerTransaction.toString() },
        })
      );
    }

    if (upserts.length > 0) {
      await prisma.$transaction(upserts);
    }

    return this.getSettings();
  }

  // ─── Platform Liability Overview ──────────────────────────────────────────────
  async getOverview(): Promise<WalletOverviewResponse> {
    const agg = await prisma.walletTransaction.groupBy({
      by: ['type'],
      _sum: { amount: true },
    });

    const totalIssued = agg.find(x => x.type === 'EARNED')?._sum.amount || 0;
    const totalUsed = agg.find(x => x.type === 'USED')?._sum.amount || 0;
    const outstandingLiability = totalIssued - totalUsed;

    return {
      totalIssued,
      totalUsed,
      outstandingLiability,
    };
  }

  // ─── Bulk Award Coins ─────────────────────────────────────────────────────────
  async bulkAward(adminId: string, dto: BulkAwardCoinsDto): Promise<BulkAwardResponse> {
    const { amount, cityId, note } = dto;

    const whereUser = cityId ? { cityId } : {};

    // 1. Fetch user IDs matching criteria
    const users = await prisma.user.findMany({
      where: whereUser,
      select: { id: true },
    });

    if (users.length === 0) return { awardedCount: 0, totalCoins: 0 };

    // 2. Map into WalletTransaction insert payloads
    const records = users.map(u => ({
      userId: u.id,
      type: 'EARNED' as const,
      amount,
      note,
    }));

    // 3. Update balances and insert logs in a transaction
    const result = await prisma.$transaction(async (tx) => {
      await tx.user.updateMany({
        where: { id: { in: users.map(u => u.id) } },
        data: { coinBalance: { increment: amount } }
      });

      return tx.walletTransaction.createMany({
        data: records,
      });
    });

    return {
      awardedCount: result.count,
      totalCoins: result.count * amount,
    };
  }
}
