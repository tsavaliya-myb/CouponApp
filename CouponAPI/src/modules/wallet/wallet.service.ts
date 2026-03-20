import { prisma } from '../../config/db';
import type { 
  WalletHistoryQueryDto,
  WalletHistoryResponse,
} from './wallet.validator';

export class WalletService {
  
  // ─── Customer: Get Wallet Balance & History ─────────────────────────────────
  async getWallet(userId: string, query: WalletHistoryQueryDto): Promise<WalletHistoryResponse> {
    const { page, limit } = query;
    const skip = (page - 1) * limit;

    // 1. Calculate Balance
    const walletAgg = await prisma.walletTransaction.groupBy({
      by: ['type'],
      where: { userId },
      _sum: { amount: true },
    });
    const earned = walletAgg.find(w => w.type === 'EARNED')?._sum.amount || 0;
    const used = walletAgg.find(w => w.type === 'USED')?._sum.amount || 0;
    const availableCoins = earned - used;

    // 2. Fetch Transaction History
    const [transactions, total] = await Promise.all([
      prisma.walletTransaction.findMany({
        where: { userId },
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.walletTransaction.count({ where: { userId } }),
    ]);

    return {
      balance: availableCoins,
      transactions: {
        data: transactions,
        meta: {
          total,
          page,
          limit,
          totalPages: Math.ceil(total / limit),
        },
      }
    };
  }
}
