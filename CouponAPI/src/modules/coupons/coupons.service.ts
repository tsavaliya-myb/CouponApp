import { prisma } from '../../config/db';
import { NotFoundError } from '../../shared/utils/AppError';
import type { MyCouponsQueryDto, SellerCouponsQueryDto } from './coupons.validator';
import { Prisma } from '@prisma/client';

export class CouponsService {
  
  // ─── Customer: Get My Instantiated Coupons ────────────────────────────────────
  async getMyCoupons(userId: string, query: MyCouponsQueryDto) {
    const { page, limit, category, sellerId } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.UserCouponWhereInput = {
      status: 'ACTIVE',
      usesRemaining: { gt: 0 },
      couponBook: {
        userId,
        // Only active coupon books (within validity period)
        validFrom: { lte: new Date() },
        validUntil: { gte: new Date() },
      },
      coupon: {
        status: 'ACTIVE',
      }
    };

    if (sellerId) {
      where.coupon!.sellerId = sellerId;
    }
    if (category) {
      where.coupon!.seller = { category };
    }

    const [userCoupons, total] = await Promise.all([
      prisma.userCoupon.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' }, // or sort by validUntil?
        include: {
          coupon: {
            include: {
              seller: {
                select: {
                  id: true,
                  businessName: true,
                  category: true,
                  area: { select: { name: true } }
                }
              }
            }
          },
          couponBook: {
            select: { validUntil: true }
          }
        },
      }),
      prisma.userCoupon.count({ where }),
    ]);

    return {
      data: userCoupons,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  // ─── Public/Customer: Get Master Coupons by Seller ────────────────────────────
  async getSellerCoupons(sellerId: string, query: SellerCouponsQueryDto) {
    const { page, limit } = query;
    const skip = (page - 1) * limit;

    // Verify seller exists
    const seller = await prisma.seller.findUnique({ where: { id: sellerId } });
    if (!seller) throw NotFoundError('Seller');

    // Return ACTIVE master coupons offered by this seller
    const where: Prisma.CouponWhereInput = {
      sellerId,
      status: 'ACTIVE',
    };

    const [coupons, total] = await Promise.all([
      prisma.coupon.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
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
}
