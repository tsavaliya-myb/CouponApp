import { prisma } from '../../config/db';
import { BadRequestError, NotFoundError } from '../../shared/utils/AppError';
import { appSettingsService } from '../admin/settings/settings.service';
import { Prisma } from '@prisma/client';
import type {
  RegisterInfluencerDto,
  UpdateInfluencerDto,
  FindInfluencersQueryDto,
  CreateServiceDto,
  UpdateServiceDto,
  CreateBookingDto,
  UpdateBookingStatusDto,
} from './influencers.validator';
import { ROLES } from '../../shared/types/roles';
import { signAccessToken, signRefreshToken } from '../../shared/utils/jwt';
import { REDIS_PREFIX, TTL } from '../../shared/constants';
import { redis } from '../../config/redis';
import crypto from 'crypto';

export class InfluencersService {
  
  // ─── Influencer Registration ──────────────────────────────────────────────────
  async register(phone: string, dto: RegisterInfluencerDto) {
    const existing = await prisma.influencer.findUnique({ where: { phone } });
    if (existing) {
      throw BadRequestError('Influencer already registered with this phone number');
    }

    const influencer = await prisma.influencer.create({
      data: {
        phone,
        fullName: dto.fullName,
        displayName: dto.displayName,
        nicheId: dto.nicheId,
        cityId: dto.cityId,
        email: dto.email,
        bio: dto.bio,
        totalFollowers: dto.totalFollowers,
        upiId: dto.upiId,
        platforms: dto.platforms || [],
        socialLinks: dto.socialLinks || {},
        status: 'PENDING',
      },
    });

    const payload = {
      userId: influencer.id,
      role: 'influencer' as const,
      phone: influencer.phone,
    };

    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, influencer.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    const fullRefreshToken = `${jti}:${refreshToken}`;

    return {
      accessToken,
      refreshToken: fullRefreshToken,
      influencer: {
        id: influencer.id,
        phone: influencer.phone,
        status: influencer.status,
      }
    };
  }

  // ─── Influencer Profile Management ────────────────────────────────────────────
  async getProfile(influencerId: string) {
    const profile = await prisma.influencer.findUnique({
      where: { id: influencerId },
      include: {
        niche: true,
        city: { select: { name: true } },
      },
    });
    if (!profile) throw NotFoundError('Influencer profile not found');
    return profile;
  }

  async updateProfile(influencerId: string, dto: UpdateInfluencerDto) {
    const profile = await prisma.influencer.findUnique({ where: { id: influencerId } });
    if (!profile) throw NotFoundError('Influencer profile not found');

    return prisma.influencer.update({
      where: { id: influencerId },
      data: dto as any,
    });
  }

  // ─── Influencer Dashboard ─────────────────────────────────────────────────────
  async getDashboard(influencerId: string) {
    const bookings = await prisma.influencerServiceBooking.findMany({
      where: { influencerId },
      include: { service: { select: { name: true } }, user: { select: { name: true, phone: true } } },
      orderBy: { createdAt: 'desc' },
    });

    const pendingStatuses = ['ENQUIRED', 'ACCEPTED', 'IN_PROGRESS'];
    let pendingCount = 0;
    let deliveredCount = 0;
    let cancelledCount = 0;
    let totalRevenue = 0;
    let totalCommissionOwed = 0;

    for (const b of bookings) {
      if (pendingStatuses.includes(b.status)) pendingCount++;
      else if (b.status === 'DELIVERED') {
        deliveredCount++;
        totalRevenue += b.pricePaid;
        totalCommissionOwed += b.commissionAmt;
      }
      else if (b.status === 'CANCELLED') cancelledCount++;
    }

    return {
      totalBookings: bookings.length,
      pendingBookings: pendingCount,
      deliveredBookings: deliveredCount,
      cancelledBookings: cancelledCount,
      totalRevenue,
      totalCommissionOwed,
      recentBookings: bookings.slice(0, 5),
    };
  }

  // ─── Services Management (Influencer) ─────────────────────────────────────────
  async getMyServices(influencerId: string) {
    return prisma.influencerService.findMany({
      where: { influencerId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async addService(influencerId: string, dto: CreateServiceDto) {
    return prisma.influencerService.create({
      data: {
        ...dto,
        influencerId,
      },
    });
  }

  async updateService(influencerId: string, serviceId: string, dto: UpdateServiceDto) {
    const service = await prisma.influencerService.findFirst({
      where: { id: serviceId, influencerId },
    });
    if (!service) throw NotFoundError('Service not found or unauthorized');

    return prisma.influencerService.update({
      where: { id: serviceId },
      data: dto,
    });
  }

  async toggleServiceStatus(influencerId: string, serviceId: string) {
    const service = await prisma.influencerService.findFirst({
      where: { id: serviceId, influencerId },
    });
    if (!service) throw NotFoundError('Service not found or unauthorized');

    const newStatus = service.status === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
    return prisma.influencerService.update({
      where: { id: serviceId },
      data: { status: newStatus },
    });
  }

  async deleteService(influencerId: string, serviceId: string) {
    const service = await prisma.influencerService.findFirst({
      where: { id: serviceId, influencerId },
    });
    if (!service) throw NotFoundError('Service not found or unauthorized');
    
    // Check if there are bookings
    const bookingsCount = await prisma.influencerServiceBooking.count({
      where: { serviceId },
    });
    
    if (bookingsCount > 0) {
      throw BadRequestError('Cannot delete a service that has existing bookings. Please set it to INACTIVE instead.');
    }

    return prisma.influencerService.delete({ where: { id: serviceId } });
  }

  // ─── Customer View ────────────────────────────────────────────────────────────
  async findInfluencers(query: FindInfluencersQueryDto) {
    const { page, limit, nicheId, cityId, platform, followerTier, search, sortBy } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.InfluencerWhereInput = {
      status: 'ACTIVE',
    };

    if (nicheId) where.nicheId = nicheId;
    if (cityId) where.cityId = cityId;
    if (platform) where.platforms = { has: platform };
    
    if (followerTier) {
      if (followerTier === 'nano') where.totalFollowers = { lt: 10000 };
      else if (followerTier === 'micro') where.totalFollowers = { gte: 10000, lt: 100000 };
      else if (followerTier === 'macro') where.totalFollowers = { gte: 100000, lt: 1000000 };
      else if (followerTier === 'mega') where.totalFollowers = { gte: 1000000 };
    }

    if (search) {
      where.OR = [
        { displayName: { contains: search, mode: 'insensitive' } },
        { fullName: { contains: search, mode: 'insensitive' } },
      ];
    }

    let orderBy: Prisma.InfluencerOrderByWithRelationInput = { createdAt: 'desc' };
    if (sortBy === 'followers') {
      orderBy = { totalFollowers: 'desc' };
    } else if (sortBy === 'bookings') {
      orderBy = { bookings: { _count: 'desc' } };
    }

    const [influencers, total] = await Promise.all([
      prisma.influencer.findMany({
        where,
        skip,
        take: limit,
        orderBy,
        include: { niche: true },
      }),
      prisma.influencer.count({ where }),
    ]);

    return {
      data: influencers,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getInfluencerPublicProfile(id: string) {
    const influencer = await prisma.influencer.findFirst({
      where: { id, status: 'ACTIVE' },
      include: {
        niche: true,
        services: { where: { status: 'ACTIVE' }, orderBy: { price: 'asc' } },
      },
    });
    if (!influencer) throw NotFoundError('Influencer not found or not active');
    return influencer;
  }

  async getActiveNiches() {
    return prisma.influencerNiche.findMany({
      where: { isActive: true },
      orderBy: { sortOrder: 'asc' },
    });
  }

  // ─── Booking Flow ─────────────────────────────────────────────────────────────
  async createBooking(userId: string, dto: CreateBookingDto) {
    const service = await prisma.influencerService.findUnique({
      where: { id: dto.serviceId },
      include: { influencer: true },
    });
    if (!service || service.status !== 'ACTIVE') throw NotFoundError('Service not available');
    if (service.influencer.status !== 'ACTIVE') throw BadRequestError('Influencer is not active');

    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw NotFoundError('User not found');

    const pricePaid = service.discountedPrice ?? service.price;
    const commissionPct = service.influencer.commissionPct;
    const commissionAmt = (pricePaid * commissionPct) / 100;

    // Handle coins
    const maxCoinsSetting = await appSettingsService.getSetting('MAX_COINS_PER_TRANSACTION', '0');
    const maxCoinsPerTx = parseInt(maxCoinsSetting, 10);
    
    const maxAllowedCoins = Math.min(
      dto.coinsToUse,
      maxCoinsPerTx,
      user.coinBalance,
      pricePaid
    );
    const coinsUsed = maxAllowedCoins;
    const coinCompensationAmt = coinsUsed; // Admin compensates influencer 1:1 for coins

    return prisma.$transaction(async (tx) => {
      const booking = await tx.influencerServiceBooking.create({
        data: {
          userId,
          influencerId: service.influencerId,
          serviceId: service.id,
          pricePaid,
          coinsUsed,
          commissionAmt,
          coinCompensationAmt,
          status: 'ENQUIRED',
          userNote: dto.userNote,
        },
      });

      if (coinsUsed > 0) {
        await tx.user.update({
          where: { id: userId },
          data: { coinBalance: { decrement: coinsUsed } },
        });

        await tx.walletTransaction.create({
          data: {
            userId,
            type: 'USED',
            amount: coinsUsed,
            influencerBookingId: booking.id,
            note: `Used on ${service.influencer.displayName}'s service`,
          },
        });
      }

      return booking;
    });
  }

  async updateBookingStatus(influencerId: string, bookingId: string, dto: UpdateBookingStatusDto) {
    const booking = await prisma.influencerServiceBooking.findFirst({
      where: { id: bookingId, influencerId },
    });
    if (!booking) throw NotFoundError('Booking not found');

    const updateData: Prisma.InfluencerServiceBookingUpdateInput = {
      status: dto.status,
    };
    if (dto.deliveryNote !== undefined) updateData.deliveryNote = dto.deliveryNote;
    
    if (dto.status === 'ACCEPTED' && booking.status === 'ENQUIRED') {
      updateData.acceptedAt = new Date();
    } else if (dto.status === 'DELIVERED') {
      updateData.deliveredAt = new Date();
    } else if (dto.status === 'CANCELLED') {
      updateData.cancelledAt = new Date();
    }

    return prisma.influencerServiceBooking.update({
      where: { id: bookingId },
      data: updateData,
    });
  }

  async getMyIncomingBookings(influencerId: string) {
    return prisma.influencerServiceBooking.findMany({
      where: { influencerId },
      include: {
        service: { select: { name: true } },
        user: { select: { name: true, phone: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getUserBookings(userId: string) {
    return prisma.influencerServiceBooking.findMany({
      where: { userId },
      include: {
        influencer: { select: { displayName: true, profilePhotoUrl: true } },
        service: { select: { name: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
