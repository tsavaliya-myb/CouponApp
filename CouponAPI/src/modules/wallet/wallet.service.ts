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

    // 1. Fetch User Balance
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { coinBalance: true }
    });
    const availableCoins = user?.coinBalance || 0;

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
