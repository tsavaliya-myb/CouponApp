import { prisma } from '../../../config/db';
import { NotFoundError } from '../../../shared/utils/AppError';
import { Prisma } from '@prisma/client';
import { oneSignal } from '../../notifications/onesignal.service';

export class AdminInfluencersService {
  
  async listInfluencers(query: any) {
    const { page, limit, status, nicheId, cityId, search } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.InfluencerWhereInput = {};

    if (status) where.status = status;
    if (nicheId) where.nicheId = nicheId;
    if (cityId) where.cityId = cityId;
    if (search) {
      where.OR = [
        { displayName: { contains: search, mode: 'insensitive' } },
        { fullName: { contains: search, mode: 'insensitive' } },
        { phone: { contains: search } },
      ];
    }

    const [data, total] = await Promise.all([
      prisma.influencer.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          niche: true,
          city: { select: { name: true } },
          _count: { select: { services: true } },
        },
      }),
      prisma.influencer.count({ where }),
    ]);

    return {
      data,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getInfluencer(id: string) {
    const influencer = await prisma.influencer.findUnique({
      where: { id },
      include: {
        niche: true,
        city: true,
        services: true,
        _count: { select: { bookings: true } },
      },
    });
    if (!influencer) throw NotFoundError('Influencer');
    return influencer;
  }

  async approveInfluencer(id: string) {
    const influencer = await prisma.influencer.update({
      where: { id },
      data: { status: 'ACTIVE' },
    });

    oneSignal.sendToSeller(
      id,
      '🎉 Account Approved!',
      'Your influencer profile is now active. You can start managing your service packages.',
      'influencer_approved'
    ).catch(() => {});

    return influencer;
  }

  async suspendInfluencer(id: string) {
    return prisma.influencer.update({ where: { id }, data: { status: 'SUSPENDED' } });
  }

  async rejectInfluencer(id: string) {
    return prisma.influencer.update({ where: { id }, data: { status: 'REJECTED' } });
  }

  async editInfluencer(id: string, dto: any) {
    return prisma.influencer.update({
      where: { id },
      data: dto,
    });
  }

  async listAllBookings(query: any) {
    const { page, limit, influencerId, status } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.InfluencerServiceBookingWhereInput = {};
    if (influencerId) where.influencerId = influencerId;
    if (status) (where as any).status = status;

    const [data, total] = await Promise.all([
      prisma.influencerServiceBooking.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          influencer: { select: { displayName: true } },
          service: { select: { name: true } },
          user: { select: { name: true, phone: true } },
        },
      }),
      prisma.influencerServiceBooking.count({ where }),
    ]);

    return {
      data,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}
