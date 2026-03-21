import { prisma } from '../../../config/db';
import { NotFoundError, BadRequestError } from '../../../shared/utils/AppError';
import { RedisCacheService } from '../../../shared/services/redisCache.service';
import { REDIS_KEYS } from '../../../shared/constants';
import type { 
  AdminCouponsQueryDto, 
  CreateCouponDto, 
  UpdateCouponDto, 
  SyncBaseCouponsDto,
  PaginatedCouponsResponse,
  CouponWithSellerResponse,
  BaseCouponResponse,
} from './admin-coupons.validator';
import { Prisma } from '@prisma/client';

export class AdminCouponsService {
  
  // ─── List Master Coupons ──────────────────────────────────────────────────────
  async listCoupons(query: AdminCouponsQueryDto): Promise<PaginatedCouponsResponse> {
    const { page, limit, sellerId, cityId, type } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.CouponWhereInput = {};

    if (sellerId) where.sellerId = sellerId;
    if (cityId) where.seller = { cityId };
    if (type) where.type = type;

    const [coupons, total] = await Promise.all([
      prisma.coupon.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          seller: { select: { businessName: true, city: { select: { name: true } } } },
        },
      }),
      prisma.coupon.count({ where }),
    ]);

    const couponIds = coupons.map(c => c.id);
    let counts: { couponId: string; totalRedemptions: number }[] = [];

    if (couponIds.length > 0) {
      counts = await prisma.$queryRaw<{ couponId: string; totalRedemptions: number }[]>`
        SELECT uc."couponId", CAST(COUNT(r.id) AS INTEGER) as "totalRedemptions"
        FROM "user_coupons" uc
        JOIN "redemptions" r ON r."userCouponId" = uc.id
        WHERE uc."couponId" IN (${Prisma.join(couponIds)})
        GROUP BY uc."couponId"
      `;
    }

    const data = coupons.map(c => {
      const match = counts.find(x => x.couponId === c.id);
      return {
        ...c,
        totalRedemptions: match ? match.totalRedemptions : 0,
      };
    });

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

  // ─── Create Coupon ────────────────────────────────────────────────────────────
  async createCoupon(dto: CreateCouponDto): Promise<CouponWithSellerResponse> {
    const seller = await prisma.seller.findUnique({ where: { id: dto.sellerId } });
    if (!seller) throw NotFoundError('Seller');

    const coupon = await prisma.coupon.create({
      data: {
        sellerId: dto.sellerId,
        discountPct: dto.discountPct,
        adminCommissionPct: dto.adminCommissionPct ?? seller.commissionPct,
        minSpend: dto.minSpend,
        maxUsesPerBook: dto.maxUsesPerBook,
        type: dto.type,
        isBaseCoupon: dto.isBaseCoupon,
      },
      include: { seller: { select: { businessName: true } } }
    });

    if (dto.isBaseCoupon) {
      await RedisCacheService.delCache(REDIS_KEYS.CITY_BASE_COUPONS(seller.cityId));
    }

    return coupon;
  }

  // ─── Update Coupon ────────────────────────────────────────────────────────────
  async updateCoupon(id: string, dto: UpdateCouponDto): Promise<BaseCouponResponse> {
    const coupon = await prisma.coupon.findUnique({ where: { id }, include: { seller: true } });
    if (!coupon) throw NotFoundError('Coupon');

    const updated = await prisma.coupon.update({
      where: { id },
      data: dto,
    });

    if (coupon.isBaseCoupon || dto.isBaseCoupon !== undefined) {
      await RedisCacheService.delCache(REDIS_KEYS.CITY_BASE_COUPONS(coupon.seller.cityId));
    }

    return updated;
  }

  // ─── Toggle Coupon Status ──────────────────────────────────────────────────────
  async toggleCouponStatus(id: string): Promise<BaseCouponResponse> {
    const coupon = await prisma.coupon.findUnique({ where: { id }, include: { seller: true } });
    if (!coupon) throw NotFoundError('Coupon');

    const newStatus = coupon.status === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';

    const updated = await prisma.coupon.update({
      where: { id },
      data: { status: newStatus },
    });

    if (coupon.isBaseCoupon) {
      await RedisCacheService.delCache(REDIS_KEYS.CITY_BASE_COUPONS(coupon.seller.cityId));
    }

    return updated;
  }

  // ─── Get City Base Coupons ────────────────────────────────────────────────────
  async getCityBaseCoupons(cityId: string): Promise<CouponWithSellerResponse[]> {
    const cacheKey = REDIS_KEYS.CITY_BASE_COUPONS(cityId);
    const cached = await RedisCacheService.getCache<any>(cacheKey);
    if (cached) return cached;

    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    const coupons = await prisma.coupon.findMany({
      where: {
        isBaseCoupon: true,
        status: 'ACTIVE',
        seller: { cityId },
      },
      include: {
        seller: { select: { businessName: true } }
      }
    });

    await RedisCacheService.setCache(cacheKey, coupons, 24 * 60 * 60); // Cache for 24h
    return coupons;
  }

  // ─── Sync City Base Coupons ───────────────────────────────────────────────────
  async syncCityBaseCoupons(cityId: string, dto: SyncBaseCouponsDto): Promise<CouponWithSellerResponse[]> {
    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    const { couponIds } = dto;

    // Verify all provided coupons belong to sellers in this city
    const targetCoupons = await prisma.coupon.findMany({
      where: { id: { in: couponIds } },
      include: { seller: true }
    });

    if (targetCoupons.length !== couponIds.length) {
      throw BadRequestError('Some provided coupon IDs were not found in the database');
    }

    const alienCoupons = targetCoupons.filter(c => c.seller.cityId !== cityId);
    if (alienCoupons.length > 0) {
      throw BadRequestError('Cannot set base coupons belonging to sellers from another city');
    }

    // Run within a transaction:
    await prisma.$transaction(async (tx) => {
      // Find all coupons currently marked as base coupons in this city
      const currentBaseIds = await tx.coupon.findMany({
        where: { seller: { cityId }, isBaseCoupon: true },
        select: { id: true }
      });
      const idsToUnset = currentBaseIds.map(c => c.id).filter(id => !couponIds.includes(id));

      if (idsToUnset.length > 0) {
        await tx.coupon.updateMany({
          where: { id: { in: idsToUnset } },
          data: { isBaseCoupon: false },
        });
      }

      if (couponIds.length > 0) {
        await tx.coupon.updateMany({
          where: { id: { in: couponIds } },
          data: { isBaseCoupon: true },
        });
      }
    });

    await RedisCacheService.delCache(REDIS_KEYS.CITY_BASE_COUPONS(cityId));
    return await this.getCityBaseCoupons(cityId);
  }
}
