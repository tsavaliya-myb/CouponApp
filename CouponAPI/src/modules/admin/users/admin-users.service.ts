import { prisma } from '../../../config/db';
import { NotFoundError } from '../../../shared/utils/AppError';
import type { 
  AdminUsersQueryDto, 
  AwardCoinsDto,
  PaginatedUsersResponse,
  UserDetailsResponse,
  BaseUserResponse,
} from './admin-users.validator';
import { Prisma } from '@prisma/client';

export class AdminUsersService {
  
  // ─── List Users ───────────────────────────────────────────────────────────────
  async listUsers(query: AdminUsersQueryDto): Promise<PaginatedUsersResponse> {
    const { page, limit, cityId, areaId, status, search } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.UserWhereInput = {};

    if (cityId) where.cityId = cityId;
    if (areaId) where.areaId = areaId;
    if (status) where.status = status;
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { phone: { contains: search } },
        { email: { contains: search, mode: 'insensitive' } },
      ];
    }

    const [users, total] = await Promise.all([
      prisma.user.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          city: { select: { name: true } },
          area: { select: { name: true } },
        },
      }),
      prisma.user.count({ where }),
    ]);

    return {
      data: users,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  // ─── Get User Details ─────────────────────────────────────────────────────────
  async getUserDetails(id: string): Promise<UserDetailsResponse> {
    const user = await prisma.user.findUnique({
      where: { id },
      include: {
        city: { select: { name: true } },
        area: { select: { name: true } },
        subscription: true,
        wallet: {
          orderBy: { createdAt: 'desc' },
          take: 5,
        },
        redemptions: {
          orderBy: { redeemedAt: 'desc' },
          take: 5,
          include: {
            seller: { select: { businessName: true } },
            userCoupon: {
              include: { coupon: { select: { type: true, discountPct: true } } }
            }
          }
        }
      },
    });

    if (!user) throw NotFoundError('User');
    return user;
  }

  // ─── Block / Unblock User ─────────────────────────────────────────────────────
  async toggleBlockStatus(id: string): Promise<BaseUserResponse> {
    const user = await prisma.user.findUnique({ where: { id } });
    if (!user) throw NotFoundError('User');

    const newStatus = user.status === 'ACTIVE' ? 'BLOCKED' : 'ACTIVE';

    return prisma.user.update({
      where: { id },
      data: { status: newStatus },
    });
  }

  // ─── Manually Award Coins ─────────────────────────────────────────────────────
  async awardCoins(userId: string, dto: AwardCoinsDto) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw NotFoundError('User');

    // This creates the transaction record.
    // The current Wallet Module (Phase 8) normally handles aggregating this, 
    // but the WalletTransaction table insertion is what actually gives coins.
    return prisma.walletTransaction.create({
      data: {
        userId,
        type: 'EARNED',
        amount: dto.amount,
        note: dto.note || 'Manually awarded by admin',
      },
    });
  }
}
