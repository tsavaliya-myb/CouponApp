import { prisma } from '../../config/db';
import { verifyQrToken } from '../../shared/utils/jwt';
import { NotFoundError, BadRequestError } from '../../shared/utils/AppError';
import type { 
  ScanQrDto, 
  ConfirmRedemptionDto, 
  RedemptionHistoryQueryDto,
  ScanQrResponse,
  ConfirmRedemptionResponse,
  CustomerRedemptionHistoryResponse,
  SellerRedemptionHistoryResponse,
} from './redemptions.validator';
import { Prisma } from '@prisma/client';
import { startOfWeek, endOfWeek } from 'date-fns';
import { redis } from '../../config/redis';
import { REDIS_PREFIX, REDIS_KEYS } from '../../shared/constants';

export class RedemptionsService {
  
  // ─── Seller: Scan QR Token ────────────────────────────────────────────────────
  async scanQrToken(sellerId: string, dto: ScanQrDto): Promise<ScanQrResponse> {
    let payload;
    try {
      payload = verifyQrToken(dto.qrToken);
    } catch (err) {
      throw BadRequestError('QR Code is invalid or has expired. Please refresh the QR code.');
    }

    const { userId } = payload;

    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        subscription: true,
      }
    });

    if (!user) throw NotFoundError('User not found');
    if (user.status === 'BLOCKED') throw BadRequestError('User account is blocked');

    // Fetch user coins balance (Sum of EARNED minus USED)
    const walletAgg = await prisma.walletTransaction.groupBy({
      by: ['type'],
      where: { userId },
      _sum: { amount: true },
    });
    const earned = walletAgg.find(w => w.type === 'EARNED')?._sum.amount || 0;
    const used = walletAgg.find(w => w.type === 'USED')?._sum.amount || 0;
    const availableCoins = earned - used;

    // Fetch eligible active coupons at this specific seller
    const eligibleCoupons = await prisma.userCoupon.findMany({
      where: {
        status: 'ACTIVE',
        usesRemaining: { gt: 0 },
        couponBook: {
          userId,
          validFrom: { lte: new Date() },
          validUntil: { gte: new Date() },
        },
        coupon: {
          sellerId,
          status: 'ACTIVE',
        }
      },
      include: {
        coupon: true,
      }
    });

    return {
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        hasActiveSubscription: user.subscription?.status === 'ACTIVE' && user.subscription.endDate > new Date(),
        availableCoins,
      },
      eligibleCoupons,
    };
  }

  // ─── Seller: Confirm Redemption ($transaction) ────────────────────────────────
  async confirmRedemption(sellerId: string, dto: ConfirmRedemptionDto): Promise<ConfirmRedemptionResponse> {
    let payload;
    try {
      // Re-verify the QR token so they can't confirm a 3-day old scan.
      payload = verifyQrToken(dto.qrToken);
    } catch (err) {
      throw BadRequestError('QR session expired. Please scan again.');
    }

    const { userId } = payload;
    const { userCouponId, billAmount, discountAmount, coinsUsed } = dto;

    const userCoupon = await prisma.userCoupon.findFirst({
      where: { id: userCouponId, couponBook: { userId } },
      include: { coupon: { include: { seller: true } }, couponBook: true }
    });

    if (!userCoupon) throw NotFoundError('Coupon not found for this user');
    if (userCoupon.coupon.sellerId !== sellerId) throw BadRequestError('Coupon belongs to a different seller');
    if (userCoupon.usesRemaining < 1 || userCoupon.status !== 'ACTIVE') throw BadRequestError('Coupon is exhausted or inactive');
    if (userCoupon.couponBook.validUntil < new Date()) throw BadRequestError('Subscription/CouponBook has expired');
    if (userCoupon.coupon.minSpend && billAmount < userCoupon.coupon.minSpend) {
      throw BadRequestError(`Minimum spend for this coupon is ₹${userCoupon.coupon.minSpend}`);
    }

    // Check Coin Balances & System Limits
    if (coinsUsed > 0) {
      const setting = await prisma.appSetting.findUnique({ where: { key: 'MAX_COINS_PER_TRANSACTION' } });
      const maxAllowed = setting ? parseInt(setting.value, 10) : 0;
      if (coinsUsed > maxAllowed) throw BadRequestError(`Maximum coins allowed per transaction is ${maxAllowed}`);

      const walletAgg = await prisma.walletTransaction.groupBy({
        by: ['type'],
        where: { userId },
        _sum: { amount: true },
      });
      const earned = walletAgg.find(w => w.type === 'EARNED')?._sum.amount || 0;
      const used = walletAgg.find(w => w.type === 'USED')?._sum.amount || 0;
      if (earned - used < coinsUsed) throw BadRequestError('Insufficient coin balance');
    }

    const finalAmount = billAmount - discountAmount - coinsUsed;
    if (finalAmount < 0) throw BadRequestError('Final amount cannot be negative');

    // Commission logic: Admin takes a % of the billAmount (or however your business logic defines it)
    // For this MVP, we calculate commission against the original bill amount.
    const commissionPct = userCoupon.coupon.adminCommissionPct ?? userCoupon.coupon.seller.commissionPct;
    const commissionAmt = (billAmount * commissionPct) / 100;
    const coinCompAmt = coinsUsed * 1; // 1 coin = ₹1 equivalent that Admin owes Seller

    // Current Week bounds for Settlement aggregation
    const now = new Date();
    const wStart = startOfWeek(now, { weekStartsOn: 1 }); // Monday start
    const wEnd = endOfWeek(now, { weekStartsOn: 1 });

    // ─── EXECUTE ATOMIC TRANSACTION ───
    const redemption = await prisma.$transaction(async (tx) => {
      
      // 1. Decrement UserCoupon uses
      await tx.userCoupon.update({
        where: { id: userCouponId },
        data: { usesRemaining: { decrement: 1 } },
      });

      // 2. Create Redemption Record
      const red = await tx.redemption.create({
        data: {
          userCouponId,
          sellerId,
          userId,
          billAmount,
          discountAmount,
          coinsUsed,
          finalAmount,
        }
      });

      // 3. Deduct Coins (if any)
      if (coinsUsed > 0) {
        await tx.walletTransaction.create({
          data: {
            userId,
            type: 'USED',
            amount: coinsUsed,
            redemptionId: red.id,
            note: `Used at ${userCoupon.coupon.seller.businessName}`,
          }
        });
      }

      // 4. Upsert Weekly Settlement & Add Settlement Line
      let settlement = await tx.settlement.findUnique({
        where: { sellerId_weekStart: { sellerId, weekStart: wStart } },
      });

      if (!settlement) {
        settlement = await tx.settlement.create({
          data: {
            sellerId,
            weekStart: wStart,
            weekEnd: wEnd,
            commissionTotal: commissionAmt,
            coinCompensationTotal: coinCompAmt,
          }
        });
      } else {
        settlement = await tx.settlement.update({
          where: { id: settlement.id },
          data: {
            commissionTotal: { increment: commissionAmt },
            coinCompensationTotal: { increment: coinCompAmt },
          }
        });
      }

      await tx.settlementLine.create({
        data: {
          settlementId: settlement.id,
          redemptionId: red.id,
          billAmount,
          commissionAmt,
          coinCompAmt,
        }
      });

      return red;
    });

    // 5. Fire Push Notification (Phase 11 stub) - Could use an EventEmitter event
    // e.g. eventEmitter.emit('redemption.confirmed', redemption.id);

    // 6. Update Seller Dashboard Redis Counters
    try {
      const endOfDayTimestamp = Math.floor(new Date(new Date().setHours(23, 59, 59, 999)).getTime() / 1000);
      const pipeline = redis.pipeline();
      const redKey = REDIS_KEYS.SELLER_REDEMPTIONS_TODAY(sellerId);
      const comKey = REDIS_KEYS.SELLER_COMMISSION_TODAY(sellerId);
      
      pipeline.incr(redKey);
      pipeline.incrbyfloat(comKey, commissionAmt);
      pipeline.expireat(redKey, endOfDayTimestamp);
      pipeline.expireat(comKey, endOfDayTimestamp);
      await pipeline.exec();
    } catch (err) {
      console.error('[Redis Dashboard Cache] Failed to increment counters', err);
    }

    return redemption;
  }

  // ─── History Helpers ──────────────────────────────────────────────────────────

  private getPeriodDates(period: 'this_week' | 'this_month' | 'all') {
    const now = new Date();
    if (period === 'this_week') {
      return { gte: startOfWeek(now, { weekStartsOn: 1 }), lte: endOfWeek(now, { weekStartsOn: 1 }) };
    }
    if (period === 'this_month') {
      return { gte: new Date(now.getFullYear(), now.getMonth(), 1), lte: new Date(now.getFullYear(), now.getMonth() + 1, 0) };
    }
    return undefined; // All time
  }

  // ─── Customer: My History ─────────────────────────────────────────────────────
  async getUserHistory(userId: string, query: RedemptionHistoryQueryDto): Promise<CustomerRedemptionHistoryResponse> {
    const { page, limit, period } = query;
    const skip = (page - 1) * limit;

    const dateFilter = this.getPeriodDates(period);
    const where: Prisma.RedemptionWhereInput = { userId, ...(dateFilter && { redeemedAt: dateFilter }) };

    const [redemptions, total] = await Promise.all([
      prisma.redemption.findMany({
        where, skip, take: limit, orderBy: { redeemedAt: 'desc' },
        include: {
          seller: { select: { businessName: true, area: { select: { name: true } } } },
          userCoupon: { include: { coupon: { select: { type: true, discountPct: true } } } }
        }
      }),
      prisma.redemption.count({ where })
    ]);

    return { data: redemptions, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
  }

  // ─── Seller: My History ───────────────────────────────────────────────────────
  async getSellerHistory(sellerId: string, query: RedemptionHistoryQueryDto): Promise<SellerRedemptionHistoryResponse> {
    const { page, limit, period } = query;
    const skip = (page - 1) * limit;

    const dateFilter = this.getPeriodDates(period);
    const where: Prisma.RedemptionWhereInput = { sellerId, ...(dateFilter && { redeemedAt: dateFilter }) };

    const [redemptions, total] = await Promise.all([
      prisma.redemption.findMany({
        where, skip, take: limit, orderBy: { redeemedAt: 'desc' },
        include: {
          user: { select: { name: true, phone: true } },
          userCoupon: { include: { coupon: { select: { type: true, discountPct: true } } } },
          settlementLine: { select: { commissionAmt: true, coinCompAmt: true } }
        }
      }),
      prisma.redemption.count({ where })
    ]);

    return { data: redemptions, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
  }
}
