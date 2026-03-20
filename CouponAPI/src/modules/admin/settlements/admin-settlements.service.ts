import { prisma } from '../../../config/db';
import { NotFoundError } from '../../../shared/utils/AppError';
import type { 
  PendingSettlementsQueryDto, 
  MarkPaidDto,
  PaginatedSettlementsResponse,
  BaseSettlementResponse,
} from './admin-settlements.validator';

export class AdminSettlementsService {
  
  // ─── List Pending Settlements ─────────────────────────────────────────────────
  async getPendingSettlements(query: PendingSettlementsQueryDto): Promise<PaginatedSettlementsResponse> {
    const { page, limit, sellerId } = query;
    const skip = (page - 1) * limit;

    const where = {
      ...(sellerId && { sellerId }),
      OR: [
        { commissionStatus: 'PENDING' },
        { coinCompStatus: 'PENDING' },
      ],
    } as any;

    const [settlements, total] = await Promise.all([
      prisma.settlement.findMany({
        where,
        skip,
        take: limit,
        orderBy: { weekStart: 'desc' },
        include: {
          seller: { select: { businessName: true, phone: true } }
        }
      }),
      prisma.settlement.count({ where }),
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

  // ─── Mark Settlement Paid ─────────────────────────────────────────────────────
  async markSettlementPaid(id: string, dto: MarkPaidDto): Promise<BaseSettlementResponse> {
    const settlement = await prisma.settlement.findUnique({ where: { id } });
    if (!settlement) throw NotFoundError('Settlement not found');

    const updateData: any = {};
    const now = new Date();

    if (dto.commissionPaid === true && settlement.commissionStatus === 'PENDING') {
      updateData.commissionStatus = 'PAID';
      updateData.commissionPaidAt = now;
    }

    if (dto.coinCompPaid === true && settlement.coinCompStatus === 'PENDING') {
      updateData.coinCompStatus = 'PAID';
      updateData.coinCompPaidAt = now;
    }

    if (Object.keys(updateData).length === 0) {
      return settlement; // No mutations necessary
    }

    return prisma.settlement.update({
      where: { id },
      data: updateData,
    });
  }
}
