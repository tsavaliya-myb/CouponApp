import { prisma } from '../../../config/db';
import { NotFoundError, BadRequestError } from '../../../shared/utils/AppError';
import type { AdminCouponsQueryDto, CreateCouponDto, UpdateCouponDto, SyncBaseCouponsDto } from './admin-coupons.validator';
import { Prisma } from '@prisma/client';

export class AdminCouponsService {
  
  // ─── List Master Coupons ──────────────────────────────────────────────────────
  async listCoupons(query: AdminCouponsQueryDto) {
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

    return {
      data: coupons,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  // ─── Create Coupon ────────────────────────────────────────────────────────────
  async createCoupon(dto: CreateCouponDto) {
    const seller = await prisma.seller.findUnique({ where: { id: dto.sellerId } });
    if (!seller) throw NotFoundError('Seller');

    return prisma.coupon.create({
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
  }

  // ─── Update Coupon ────────────────────────────────────────────────────────────
  async updateCoupon(id: string, dto: UpdateCouponDto) {
    const coupon = await prisma.coupon.findUnique({ where: { id } });
    if (!coupon) throw NotFoundError('Coupon');

    return prisma.coupon.update({
      where: { id },
      data: dto,
    });
  }

  // ─── Deactivate Coupon ────────────────────────────────────────────────────────
  async deactivateCoupon(id: string) {
    const coupon = await prisma.coupon.findUnique({ where: { id } });
    if (!coupon) throw NotFoundError('Coupon');

    // Soft delete/Deactivate
    return prisma.coupon.update({
      where: { id },
      data: { status: 'INACTIVE' },
    });
  }

  // ─── Get City Base Coupons ────────────────────────────────────────────────────
  async getCityBaseCoupons(cityId: string) {
    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    return prisma.coupon.findMany({
      where: {
        isBaseCoupon: true,
        status: 'ACTIVE',
        seller: { cityId },
      },
      include: {
        seller: { select: { businessName: true } }
      }
    });
  }

  // ─── Sync City Base Coupons ───────────────────────────────────────────────────
  async syncCityBaseCoupons(cityId: string, dto: SyncBaseCouponsDto) {
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
    // 1. Unset all current base coupons for this city
    // 2. Set the requested ones as true.
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

    return await this.getCityBaseCoupons(cityId);
  }
}
