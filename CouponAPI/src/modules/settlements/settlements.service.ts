import { prisma } from '../../config/db';
import { NotFoundError } from '../../shared/utils/AppError';
import type { 
  SettlementsQueryDto,
  PaginatedSettlementsResponse,
  SettlementDetailResponse,
} from './settlements.validator';

export class SettlementsService {

  // ─── List My Seller - Settlements ─────────────────────────────────────────────
  async getMySettlements(sellerId: string, query: SettlementsQueryDto): Promise<PaginatedSettlementsResponse> {
    const { page, limit } = query;
    const skip = (page - 1) * limit;

    const [settlements, total] = await Promise.all([
      prisma.settlement.findMany({
        where: { sellerId },
        skip,
        take: limit,
        orderBy: { weekStart: 'desc' },
      }),
      prisma.settlement.count({ where: { sellerId } }),
    ]);

    return {
      data: settlements,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  // ─── Get Week Summary Detail (Seller) ─────────────────────────────────────────
  async getSettlementDetail(sellerId: string, settlementId: string): Promise<SettlementDetailResponse> {
    const settlement = await prisma.settlement.findFirst({
      where: { id: settlementId, sellerId },
      include: {
        settlementLines: {
          include: {
            redemption: {
              include: {
                userCoupon: { include: { coupon: { select: { type: true, discountPct: true } } } }
              }
            }
          },
          orderBy: { createdAt: 'desc' }
        }
      }
    });

    if (!settlement) throw NotFoundError('Settlement details not found for this week');
    return settlement;
  }
}
