import { prisma } from '../../config/db';
import { signAccessToken, signRefreshToken } from '../../shared/utils/jwt';
import { ConflictError, NotFoundError, BadRequestError } from '../../shared/utils/AppError';
import { REDIS_PREFIX, TTL } from '../../shared/constants';
import { redis } from '../../config/redis';
import crypto from 'crypto';
import type {
  RegisterSellerDto,
  UpdateSellerDto,
  FindSellersDto,
  GetSellersByAreaCategoryDto,
  LoginSellerResponse,
  ProfileResponse,
  SellerDashboardResponse,
  PaginatedDistanceSellersResponse,
} from './sellers.validator';

// ─── Haversine Distance Utility ───────────────────────────────────────────────
function getDistanceFromLatLonInKm(lat1: number, lon1: number, lat2: number, lon2: number) {
  const R = 6371; // Radius of the earth in km
  const dLat = (lat2 - lat1) * (Math.PI / 180);  // deg2rad below
  const dLon = (lon2 - lon1) * (Math.PI / 180);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const d = R * c; // Distance in km
  return d;
}

export class SellersService {

  // ─── Register ────────────────────────────────────────
  async register(phone: string, dto: RegisterSellerDto): Promise<LoginSellerResponse> {
    const existingSeller = await prisma.seller.findUnique({
      where: { phone },
    });

    if (existingSeller) {
      throw ConflictError('A seller with this phone number is already registered.');
    }

    const seller = await prisma.seller.create({
      data: {
        phone,
        businessName: dto.businessName,
        category: dto.category,
        cityId: dto.cityId,
        areaId: dto.areaId,
        address: dto.address,
        email: dto.email,
        upiId: dto.upiId,
        latitude: dto.lat,
        longitude: dto.lng,
      },
    });

    const payload = {
      userId: seller.id,
      role: 'seller' as const,
      phone: seller.phone,
    };

    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, seller.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    return {
      accessToken,
      refreshToken: `${jti}:${refreshToken}`,
      seller: {
        id: seller.id,
        phone: seller.phone,
        businessName: seller.businessName,
        category: seller.category,
        cityId: seller.cityId,
        areaId: seller.areaId,
        address: seller.address,
        email: seller.email,
        upiId: seller.upiId,
        lat: seller.latitude,
        lng: seller.longitude,
        status: seller.status,
      },
      message: 'Account created. Waiting for admin approval to appear in search.',
    };
  }

  // ─── Profile Management ───────────────────────────────────────────────────────
  async getProfile(sellerId: string): Promise<ProfileResponse> {
    const seller = await prisma.seller.findUnique({
      where: { id: sellerId },
      include: {
        city: { select: { id: true, name: true } },
        area: { select: { id: true, name: true } },
        media: true,
      },
    });

    if (!seller) throw NotFoundError('Seller profile not found');
    return seller;
  }

  async updateProfile(sellerId: string, dto: UpdateSellerDto): Promise<ProfileResponse> {
    const seller = await prisma.seller.findUnique({ where: { id: sellerId } });
    if (!seller) throw NotFoundError('Seller profile not found');

    return prisma.seller.update({
      where: { id: sellerId },
      data: dto,
      include: {
        city: { select: { id: true, name: true } },
        area: { select: { id: true, name: true } },
      },
    });
  }

  // ─── Media Management ─────────────────────────────────────────────────────────
  async getSellerMedia(sellerId: string) {
    const media = await prisma.sellerMedia.findUnique({
      where: { sellerId },
    });
    // It's possible a seller doesn't have media yet, so we could just return null or empty object. 
    // Let's return it directly. If they want an error when not found, we can throw one. 
    // Let's return the media or an empty object.
    if (!media) {
       throw NotFoundError('Media not found for this seller');
    }
    return media;
  }

  async updateSellerLogo(sellerId: string, logoUrl: string) {
    return prisma.sellerMedia.upsert({
      where: { sellerId },
      update: { logoUrl },
      create: { sellerId, logoUrl },
    });
  }

  async updateSellerMediaFiles(
    sellerId: string,
    media: { photoUrl1?: string, photoUrl2?: string, videoUrl?: string }
  ) {
    return prisma.sellerMedia.upsert({
      where: { sellerId },
      update: media,
      create: { sellerId, ...media },
    });
  }

  // ─── Dashboard ────────────────────────────────────────────────────────────────
  async getDashboard(sellerId: string): Promise<SellerDashboardResponse> {
    const seller = await prisma.seller.findUnique({ where: { id: sellerId } });
    if (!seller) throw NotFoundError('Seller profile not found');

    const totalRedemptions = await prisma.redemption.count({
      where: { sellerId },
    });

    // Date boundaries
    const now = new Date();
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - 7);
    startOfWeek.setHours(0, 0, 0, 0);

    const todaysRedemptions = await prisma.redemption.count({
      where: {
        sellerId,
        redeemedAt: { gte: startOfToday },
      },
    });

    const thisWeekRedemptions = await prisma.redemption.count({
      where: {
        sellerId,
        redeemedAt: { gte: startOfWeek },
      },
    });

    const commissionAggregation = await prisma.settlement.aggregate({
      _sum: { commissionTotal: true },
      where: { sellerId, commissionStatus: 'PENDING' },
    });
    const commissionOwed = commissionAggregation._sum.commissionTotal || 0;

    const coinAggregation = await prisma.settlement.aggregate({
      _sum: { coinCompensationTotal: true },
      where: { sellerId, coinCompStatus: 'PENDING' },
    });
    const coinReceivable = coinAggregation._sum.coinCompensationTotal || 0;

    const recentRedemptionsData = await prisma.redemption.findMany({
      where: { sellerId },
      orderBy: { redeemedAt: 'desc' },
      take: 3,
      include: {
        userCoupon: {
          include: {
            coupon: true,
          },
        },
      },
    });

    const recentRedemptions = recentRedemptionsData.map(r => {
      const couponIdSuffix = r.userCoupon.coupon.id.substring(0, 4).toUpperCase();
      const typeStr = r.userCoupon.coupon.type === 'BOGO' ? 'BOGO Offer' : 'Store Coupon';
      return {
        id: r.id,
        couponName: `${typeStr} #${couponIdSuffix}`,
        amount: r.finalAmount,
        createdAt: r.redeemedAt,
      };
    });

    return {
      totalRedemptions,
      status: seller.status,
      commissionPct: seller.commissionPct,
      todaysRedemptions,
      thisWeekRedemptions,
      commissionOwed,
      coinReceivable,
      recentRedemptions,
    };
  }

  // ─── Customer View: Find Sellers (Haversine Sorted) ─────────────────────────
  async findSellersNearUser(dto: FindSellersDto): Promise<PaginatedDistanceSellersResponse> {
    const { lat, lng, limit, cityId, search, page } = dto;

    // Only fetch ACTIVE sellers
    const whereClause: any = { status: 'ACTIVE' };
    if (cityId) whereClause.cityId = cityId;
    if (search) {
      whereClause.businessName = { contains: search, mode: 'insensitive' };
    }

    // Since Prisma cannot perform Haversine distance sorts natively without Raw Queries, 
    // and this is an MVP, we fetch candidates and sort them in JavaScript.
    // In production with millions of sellers, you'd use raw SQL with PostGIS or earthdistance.
    const sellers = await prisma.seller.findMany({
      where: whereClause,
      include: {
        area: { select: { name: true } },
        media: { select: { logoUrl: true, photoUrl1: true, photoUrl2: true, videoUrl: true } },
      },
    });

    const sellersWithDistance = sellers.map(seller => {
      let distanceKm = null;
      if (seller.latitude !== null && seller.longitude !== null) {
        distanceKm = getDistanceFromLatLonInKm(lat, lng, seller.latitude, seller.longitude);
      }
      return {
        id: seller.id,
        businessName: seller.businessName,
        category: seller.category,
        area: seller.area?.name,
        lat: seller.latitude,
        lng: seller.longitude,
        logoUrl: seller.media?.logoUrl ?? null,
        media: seller.media ?? null,
        distanceKm,
      };
    });

    // Sort by distance (closest first). Push sellers without coordinates to the end.
    sellersWithDistance.sort((a, b) => {
      if (a.distanceKm === null) return 1;
      if (b.distanceKm === null) return -1;
      return a.distanceKm - b.distanceKm;
    });

    const total = sellersWithDistance.length;
    const skip = (page - 1) * limit;
    const paginatedData = sellersWithDistance.slice(skip, skip + limit);

    return {
      data: paginatedData,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      }
    };
  }

  // ─── Customer View: Get Sellers by Area and Category ──────────────────────────
  async getSellersByAreaCategory(dto: GetSellersByAreaCategoryDto): Promise<PaginatedDistanceSellersResponse> {
    const { areaId, categoryType, page, limit } = dto;

    const whereClause: any = {
      status: 'ACTIVE',
      areaId,
    };

    if (categoryType) {
      whereClause.category = categoryType;
    }

    const total = await prisma.seller.count({ where: whereClause });
    const skip = (page - 1) * limit;

    const sellers = await prisma.seller.findMany({
      where: whereClause,
      include: {
        area: { select: { name: true } },
        media: { select: { logoUrl: true, photoUrl1: true, photoUrl2: true, videoUrl: true } },
      },
      skip,
      take: limit,
      orderBy: { businessName: 'asc' }, // Order by name ascending
    });

    const paginatedData = sellers.map(seller => ({
      id: seller.id,
      businessName: seller.businessName,
      category: seller.category,
      area: seller.area?.name ?? null,
      lat: seller.latitude ?? null,
      lng: seller.longitude ?? null,
      logoUrl: seller.media?.logoUrl ?? null,
      media: seller.media ?? null,
      distanceKm: null,
    }));

    return {
      data: paginatedData,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      }
    };
  }
}
