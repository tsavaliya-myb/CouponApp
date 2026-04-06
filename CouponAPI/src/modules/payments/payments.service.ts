import { getRazorpay } from '../../config/razorpay';
import { prisma } from '../../config/db';
import { redis } from '../../config/redis';
import { env } from '../../config/env';
import { ConflictError } from '../../shared/utils/AppError';
import type { CreateOrderResponse } from './payments.validator';

// ─── Razorpay Webhook Event Shape (simplified) ────────────────────────────────
interface RazorpayWebhookPayload {
  event: string;
  payload: {
    payment: {
      entity: {
        id: string;          // razorpay_payment_id
        order_id: string;    // razorpay_order_id
        amount: number;      // in paise
        status: string;
        notes: {
          userId?: string;
        };
      };
    };
  };
}

export class PaymentService {

  // ─── Create Razorpay Order ────────────────────────────────────────────────
  async createOrder(userId: string): Promise<CreateOrderResponse> {
    // Check for existing active subscription
    const existingSub = await prisma.subscription.findUnique({
      where: { userId },
    });
    if (existingSub?.status === 'ACTIVE') {
      throw ConflictError('User already has an active subscription');
    }

    // Get subscription price from AppSetting (key: subscription_price)
    const priceSetting = await prisma.appSetting.findUnique({
      where: { key: 'subscription_price' },
    });
    const priceInRupees = priceSetting ? parseFloat(priceSetting.value) : 1000;
    const amountInPaise = Math.round(priceInRupees * 100);

    // Create Razorpay order
    const order = await getRazorpay().orders.create({
      amount: amountInPaise,
      currency: 'INR',
      receipt: `sub_${userId}_${Date.now()}`,
      notes: { userId }, // embed userId so webhook can locate the user
    });

    return {
      orderId: order.id,
      amount: amountInPaise,
      currency: 'INR',
      keyId: env.RAZORPAY_KEY_ID,
    };
  }

  // ─── Handle Incoming Webhook ──────────────────────────────────────────────
  async handleWebhook(payload: RazorpayWebhookPayload): Promise<void> {
    if (payload.event !== 'payment.captured') {
      // Silently ignore unrelated events
      return;
    }

    const payment = payload.payload.payment.entity;
    const razorpayPaymentId = payment.id;
    const userId = payment.notes?.userId;

    if (!userId) {
      console.error('[Webhook] Missing userId in notes, cannot fulfil subscription');
      return;
    }

    // ── Idempotency guard: skip if already processed ──────────────────────
    const idempotencyKey = `payment_processed:${razorpayPaymentId}`;
    const alreadyProcessed = await redis.get(idempotencyKey);
    if (alreadyProcessed) {
      console.log(`[Webhook] Payment ${razorpayPaymentId} already processed. Skipping.`);
      return;
    }

    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      console.error(`[Webhook] User ${userId} not found`);
      return;
    }

    // ── Read AppSettings ──────────────────────────────────────────────────
    const [validityDaySetting, coinsSetting] = await Promise.all([
      prisma.appSetting.findUnique({ where: { key: 'book_validity_days' } }),
      prisma.appSetting.findUnique({ where: { key: 'coins_per_subscription' } }),
    ]);
    const validityDays = validityDaySetting ? parseInt(validityDaySetting.value) : 30;
    const coinsToAward = coinsSetting ? parseInt(coinsSetting.value) : 50;

    // ── Fetch base coupons for the user's city ────────────────────────────
    const baseCoupons = user.cityId
      ? await prisma.coupon.findMany({
        where: {
          isBaseCoupon: true,
          status: 'ACTIVE',
          seller: { cityId: user.cityId },
        },
      })
      : [];

    const now = new Date();
    const endDate = new Date(now);
    endDate.setDate(endDate.getDate() + validityDays);

    // ── Atomic transaction: subscription + coupon book + coins ────────────
    await prisma.$transaction(async (tx) => {
      // 1. Create or renew Subscription
      const subscription = await tx.subscription.upsert({
        where: { userId },
        create: {
          userId,
          startDate: now,
          endDate,
          status: 'ACTIVE',
          razorpayPaymentId,
        },
        update: {
          startDate: now,
          endDate,
          status: 'ACTIVE',
          razorpayPaymentId,
        },
      });

      // 2. Create CouponBook
      const couponBook = await tx.couponBook.create({
        data: {
          subscriptionId: subscription.id,
          userId,
          validFrom: now,
          validUntil: endDate,
        },
      });

      // 3. Seed UserCoupons from base coupons
      if (baseCoupons.length > 0) {
        await tx.userCoupon.createMany({
          data: baseCoupons.map((c) => ({
            couponBookId: couponBook.id,
            couponId: c.id,
            usesRemaining: c.maxUsesPerBook,
            status: 'ACTIVE' as const,
          })),
          skipDuplicates: true,
        });
      }

      // 4. Award coins via WalletTransaction + update cached balance
      await tx.walletTransaction.create({
        data: {
          userId,
          type: 'EARNED',
          amount: coinsToAward,
          note: 'Subscription bonus coins',
        },
      });
      await tx.user.update({
        where: { id: userId },
        data: { coinBalance: { increment: coinsToAward } },
      });
    });

    // ── Mark as processed in Redis for 48h (idempotency window) ──────────
    await redis.set(idempotencyKey, '1', 'EX', 48 * 60 * 60);

    console.log(`[Webhook] Subscription fulfilled for user ${userId}, payment ${razorpayPaymentId}`);
  }
}
