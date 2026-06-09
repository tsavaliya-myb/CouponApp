import { prisma } from '../../config/db';
import { signAccessToken, signRefreshToken } from '../../shared/utils/jwt';
import { ConflictError, NotFoundError, BadRequestError } from '../../shared/utils/AppError';
import { REDIS_PREFIX, TTL } from '../../shared/constants';
import { redis } from '../../config/redis';
import crypto from 'crypto';
import type {
  RegisterUserDto,
  UpdateUserDto,
  LoginUserResponse,
  ProfileResponse,
  QrTokenResponse,
} from './users.validator';

export class UsersService {

  // ─── Register (Bypasses OTP for MVP) ────────────────────────────────────────

  async register(dto: RegisterUserDto): Promise<LoginUserResponse> {
    // Note: In full implementation, this should verify OTP first.
    // We are trusting the phone number directly for MVP Phase 3.

    let user = await prisma.user.findUnique({
      where: { phone: dto.phone },
    });

    if (user) {
      // If user already exists, we just rotate tokens (essentially a login)
      // Throw Conflict if the app strictly expects 'register' to fail on duplicate
      // but for ease of use, we update missing details if provided.
      if (dto.name || dto.email || dto.cityId || dto.areaId) {
        user = await prisma.user.update({
          where: { id: user.id },
          data: {
            name: dto.name || user.name,
            email: dto.email || user.email,
            cityId: dto.cityId || user.cityId,
            areaId: dto.areaId || user.areaId,
          }
        });
      }
    } else {
      user = await prisma.user.create({
        data: {
          phone: dto.phone,
          name: dto.name,
          email: dto.email,
          cityId: dto.cityId,
          areaId: dto.areaId,
        },
      });
    }

    if (user.status === 'BLOCKED') {
      throw BadRequestError('User account is blocked. Please contact support.');
    }

    const payload = {
      userId: user.id,
      role: 'customer' as const,
      phone: user.phone,
    };

    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, user.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    return {
      accessToken,
      refreshToken: `${jti}:${refreshToken}`,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        email: user.email,
        cityId: user.cityId,
        areaId: user.areaId,
        status: user.status,
      },
    };
  }

  // ─── Profile Management ───────────────────────────────────────────────────────

  async getProfile(userId: string): Promise<ProfileResponse> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        city: { select: { id: true, name: true } },
        area: { select: { id: true, name: true } },
        subscription: { select: { status: true, endDate: true } },
      },
    });

    if (!user) throw NotFoundError('User profile not found');

    return {
      ...user,
      subscriptionStatus:
        user.subscription?.status === 'ACTIVE' && user.subscription.endDate > new Date()
          ? 'ACTIVE'
          : 'NONE',
    };
  }

  async updateProfile(userId: string, dto: UpdateUserDto): Promise<ProfileResponse> {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw NotFoundError('User profile not found');

    if (dto.email && dto.email !== user.email) {
      const emailTaken = await prisma.user.findFirst({ where: { email: dto.email } });
      if (emailTaken) throw ConflictError('Email is already in use by another account');
    }

    // Handle Referral Code processing during profile completion
    if (dto.referralCode && dto.referralCode !== user.referralCode) {
      // Ensure user hasn't already been referred
      const existingReferral = await prisma.referral.findFirst({
        where: { referredId: userId },
      });
      if (!existingReferral) {
        // Find referrer by code
        const referrer = await prisma.user.findUnique({
          where: { referralCode: dto.referralCode },
        });
        
        if (referrer && referrer.id !== userId) {
          // Check limits from settings or enforce later during subscription purchase
          // We'll create the PENDING referral here.
          await prisma.referral.create({
            data: {
              referrerId: referrer.id,
              referredId: userId,
              status: 'PENDING',
            },
          });
        }
      }
    }

    // Extract referralCode from dto so we don't try to update the user with it 
    // (since it belongs to the referrer, or if we do want to store it, we shouldn't overwrite the user's own code)
    const { referralCode, ...updateData } = dto;

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: updateData,
      include: {
        city: { select: { id: true, name: true } },
        area: { select: { id: true, name: true } },
        subscription: { select: { status: true, endDate: true } },
      },
    });

    return {
      ...updatedUser,
      subscriptionStatus:
        updatedUser.subscription?.status === 'ACTIVE' && updatedUser.subscription.endDate > new Date()
          ? 'ACTIVE'
          : 'NONE',
    };
  }

  // ─── App Settings ─────────────────────────────────────────────────────────────

  async getAppSettings() {
    const [settings, totalActiveCoupons] = await Promise.all([
      prisma.appSetting.findMany({
        where: {
          key: { in: ['subscription_price', 'book_validity_days', 'MAX_COINS_PER_TRANSACTION'] },
        },
        select: { key: true, value: true },
      }),
      prisma.coupon.count({ where: { status: 'ACTIVE' } }),
    ]);

    const map = Object.fromEntries(settings.map((s) => [s.key, s.value]));

    return {
      subscriptionPrice: parseFloat(map['subscription_price'] ?? '1000'),
      bookValidityDays: parseInt(map['book_validity_days'] ?? '30', 10),
      maxCoinsPerTransaction: parseInt(map['MAX_COINS_PER_TRANSACTION'] ?? '0', 10),
      totalActiveCoupons,
    };
  }

  // ─── Referral Stats ────────────────────────────────────────────────────────────

  async getReferralStats(userId: string) {
    let user = await prisma.user.findUnique({
      where: { id: userId },
      select: { referralCode: true }
    });

    if (!user) throw NotFoundError('User not found');

    if (!user.referralCode) {
      const newReferralCode = crypto.randomBytes(4).toString('hex').toUpperCase();
      await prisma.user.update({
        where: { id: userId },
        data: { referralCode: newReferralCode }
      });
      user.referralCode = newReferralCode;
    }

    const successfulReferrals = await prisma.referral.count({
      where: { referrerId: userId, status: 'SUCCESSFUL' }
    });

    const maxLimitSetting = await prisma.appSetting.findUnique({ where: { key: 'max_referrals' } });
    const maxLimit = maxLimitSetting ? parseInt(maxLimitSetting.value, 10) : 10;

    const rewardTxs = await prisma.walletTransaction.aggregate({
      _sum: { amount: true },
      where: { userId, note: { contains: 'Referral Bonus' } }
    });

    return {
      referralCode: user.referralCode,
      successfulReferrals,
      maxLimit,
      totalEarnedCoins: rewardTxs._sum.amount || 0,
    };
  }

  // ─── Leaderboard ─────────────────────────────────────────────────────────────

  async getLeaderboard(type: string, timeFrame: string) {
    let startDate: Date | undefined;
    const now = new Date();

    if (timeFrame === 'week') {
      const day = now.getDay();
      const diff = now.getDate() - day + (day === 0 ? -6 : 1);
      startDate = new Date(now.setDate(diff));
      startDate.setHours(0, 0, 0, 0);
    } else if (timeFrame === 'month') {
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    }

    if (type === 'savers') {
      const topSavers = await prisma.redemption.groupBy({
        by: ['userId'],
        _sum: { discountAmount: true },
        where: {
          redeemedAt: startDate ? { gte: startDate } : undefined,
        },
        orderBy: {
          _sum: { discountAmount: 'desc' },
        },
        take: 100,
      });

      const userIds = topSavers.map(s => s.userId);
      const users = await prisma.user.findMany({
        where: { id: { in: userIds } },
        select: { id: true, name: true }
      });

      return topSavers.map((s, index) => {
        const user = users.find(u => u.id === s.userId);
        return {
          id: s.userId,
          name: user?.name || 'Unknown',
          avatarUrl: null,
          metricValue: s._sum.discountAmount || 0,
          rank: index + 1,
        };
      });
    } else if (type === 'spenders') {
      const topSpenders = await prisma.redemption.groupBy({
        by: ['userId'],
        _sum: { finalAmount: true },
        where: {
          redeemedAt: startDate ? { gte: startDate } : undefined,
        },
        orderBy: {
          _sum: { finalAmount: 'desc' },
        },
        take: 100,
      });

      const userIds = topSpenders.map(s => s.userId);
      const users = await prisma.user.findMany({
        where: { id: { in: userIds } },
        select: { id: true, name: true }
      });

      return topSpenders.map((s, index) => {
        const user = users.find(u => u.id === s.userId);
        return {
          id: s.userId,
          name: user?.name || 'Unknown',
          avatarUrl: null,
          metricValue: s._sum.finalAmount || 0,
          rank: index + 1,
        };
      });
    }

    throw BadRequestError('Invalid leaderboard type');
  }
}
