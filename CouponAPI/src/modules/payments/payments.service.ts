import crypto from 'crypto';
import { prisma } from '../../config/db';
import { redis } from '../../config/redis';
import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { ConflictError } from '../../shared/utils/AppError';
import { razorpay, toPaise } from '../../config/razorpay';
import { verifyWebhookSignature, verifyPaymentSignature } from '../../shared/utils/razorpaySignature';
import { oneSignal } from '../notifications/onesignal.service';
import type { User } from '@prisma/client';

const log = logger.child({ module: 'PaymentService' });

export class PaymentService {

  // ─── Razorpay Customer (created once per user, cached on User) ──────────
  private async getOrCreateCustomer(user: User): Promise<string> {
    if (user.razorpayCustomerId) {
      // A customer id cached while the server ran under a *different* key mode
      // (test vs live) will not exist in the current mode — Razorpay has no
      // test/live prefix on customer ids, so the only way to tell is to ask.
      // Self-heal by minting a fresh one instead of handing Checkout a dead id
      // (surfaces there as "The id provided does not exist").
      try {
        await razorpay.customers.fetch(user.razorpayCustomerId);
        return user.razorpayCustomerId;
      } catch (err) {
        log.warn('getOrCreateCustomer: cached razorpayCustomerId not found in current mode — reissuing', {
          userId: user.id, staleCustomerId: user.razorpayCustomerId, err,
        });
      }
    }

    const contact = (user.phone || '').replace(/^\+91/, '');
    const customer = await razorpay.customers.create({
      name: user.name ?? 'Customer',
      email: user.email || undefined,
      contact,
      fail_existing: 0, // if a customer with this contact/email exists, reuse it
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { razorpayCustomerId: customer.id },
    });

    return customer.id;
  }

  // ─── Initiate Razorpay UPI Autopay Mandate ───────────────────────────────
  async initiatePayment(userId: string) {
    log.info('initiatePayment: start', { userId });

    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      log.error('initiatePayment: user not found', { userId });
      throw ConflictError('User not found');
    }

    const existingSub = await prisma.subscription.findUnique({ where: { userId } });
    if (existingSub?.status === 'ACTIVE') {
      log.warn('initiatePayment: user already has active subscription', { userId });
      throw ConflictError('User already has an active subscription');
    }

    const priceSetting = await prisma.appSetting.findUnique({
      where: { key: 'subscription_price' },
    });
    const rupees = priceSetting ? parseFloat(priceSetting.value) : 999;
    const amountPaise = toPaise(rupees);

    if (amountPaise > env.RAZORPAY_MANDATE_MAX_AMOUNT) {
      log.error('initiatePayment: subscription_price exceeds mandate max_amount', {
        userId, amountPaise, maxAmount: env.RAZORPAY_MANDATE_MAX_AMOUNT,
      });
      throw ConflictError('Subscription price exceeds the payment gateway limit. Please contact support.');
    }

    const customerId = await this.getOrCreateCustomer(user);

    const expireAt = Math.floor(
      new Date(new Date().setFullYear(new Date().getFullYear() + env.RAZORPAY_MANDATE_YEARS)).getTime() / 1000,
    );

    const order = await razorpay.orders.create({
      amount:      amountPaise,
      currency:    'INR',
      customer_id: customerId,
      method:      'upi',
      token: {
        max_amount: env.RAZORPAY_MANDATE_MAX_AMOUNT,
        expire_at:  expireAt,
        // 'monthly' caps us at ≤1 debit per calendar month. Renewals fire
        // ~45–50 days apart — always under that cap.
        frequency:  'monthly',
      },
      receipt: `sub_${userId.slice(0, 8)}_${Date.now()}`.slice(0, 40),
      notes:   { userId, kind: 'MANDATE' },
    });

    await prisma.paymentAttempt.create({
      data: {
        userId,
        razorpayOrderId: order.id,
        amount:          rupees.toFixed(2) as any,
        kind:            'MANDATE',
        status:          'PENDING',
      },
    });

    log.info('initiatePayment: order created', { userId, orderId: order.id, amountPaise });

    return {
      keyId:       env.RAZORPAY_KEY_ID,
      orderId:     order.id,
      customerId,
      amount:      amountPaise,
      currency:    'INR',
      name:        'CouponApp',
      description: 'CouponApp Premium — Coupon Book',
      recurring:   '1',
      prefill: {
        name:    user.name ?? 'Customer',
        email:   user.email ?? '',
        contact: (user.phone ?? '').replace(/^\+91/, ''),
      },
    };
  }

  // ─── Client-side verify (optimistic fulfilment ahead of the webhook) ────
  async verifyPayment(
    userId: string,
    params: { orderId: string; paymentId: string; signature: string },
  ): Promise<{ status: string }> {
    const { orderId, paymentId, signature } = params;

    if (!verifyPaymentSignature(orderId, paymentId, signature, env.RAZORPAY_KEY_SECRET)) {
      log.error('verifyPayment: signature mismatch', { userId, orderId, paymentId });
      throw ConflictError('Payment verification failed');
    }

    const attempt = await prisma.paymentAttempt.findUnique({ where: { razorpayOrderId: orderId } });
    if (!attempt || attempt.userId !== userId) {
      log.error('verifyPayment: order not found or user mismatch', { userId, orderId });
      throw ConflictError('Payment record not found');
    }

    if (attempt.status === 'SUCCESS') {
      return { status: 'already_processed' };
    }

    const payment = await razorpay.payments.fetch(paymentId);
    if (payment.order_id !== orderId) {
      log.error('verifyPayment: payment/order mismatch', { userId, orderId, paymentId, paymentOrderId: payment.order_id });
      throw ConflictError('Payment verification failed');
    }

    if (payment.status !== 'captured') {
      log.warn('verifyPayment: payment not yet captured', { userId, orderId, paymentId, status: payment.status });
      return { status: payment.status };
    }

    await this.onPaymentCaptured(payment);
    return { status: 'captured' };
  }

  // ─── Handle Incoming Razorpay Webhook ────────────────────────────────────
  async handleWebhook(rawBody: Buffer, signature: string): Promise<void> {
    if (!verifyWebhookSignature(rawBody, signature, env.RAZORPAY_WEBHOOK_SECRET)) {
      log.error('webhook: signature verification failed — rejected');
      return;
    }

    // Idempotency key derived from the body itself — doesn't depend on any
    // particular header being present. Razorpay retries for up to 24h.
    const idKey = `rzp_event:${crypto.createHash('sha256').update(rawBody).digest('hex')}`;
    const isNew = await redis.set(idKey, '1', 'EX', 48 * 3600, 'NX');
    if (isNew !== 'OK') {
      log.warn('webhook: duplicate delivery ignored');
      return;
    }

    let body: any;
    try {
      body = JSON.parse(rawBody.toString('utf8'));
    } catch (err) {
      log.error('webhook: invalid JSON body', { err });
      return;
    }

    log.info('webhook: received', { event: body.event });

    switch (body.event) {
      case 'payment.captured':
        return this.onPaymentCaptured(body.payload?.payment?.entity);
      case 'payment.failed':
        return this.onPaymentFailed(body.payload?.payment?.entity);
      case 'token.confirmed':
        return this.onTokenConfirmed(body.payload?.token?.entity);
      case 'token.cancelled':
      case 'token.paused':
      case 'token.rejected':
        return this.onTokenRevoked(body.payload?.token?.entity);
      default:
        log.info('webhook: unhandled event', { event: body.event });
    }
  }

  // ─── payment.captured — MANDATE → fulfil, RENEWAL → extend ──────────────
  private async onPaymentCaptured(payment: any): Promise<void> {
    if (!payment?.id || !payment?.order_id) {
      log.error('onPaymentCaptured: malformed payment payload', { payment });
      return;
    }

    const attempt = await prisma.paymentAttempt.findUnique({ where: { razorpayOrderId: payment.order_id } });
    if (!attempt) {
      log.error('onPaymentCaptured: no PaymentAttempt for order', { orderId: payment.order_id, paymentId: payment.id });
      return;
    }
    if (attempt.status === 'SUCCESS') {
      log.info('onPaymentCaptured: already processed', { orderId: payment.order_id });
      return;
    }

    const tokenId: string | null = payment.token_id ?? null;

    if (attempt.kind === 'MANDATE') {
      try {
        await this.fulfillSubscription(attempt.userId, payment.id, tokenId);
      } catch (err) {
        log.error('onPaymentCaptured: fulfillSubscription threw — subscription NOT activated', {
          userId: attempt.userId, orderId: payment.order_id, err,
        });
      }
    } else if (attempt.kind === 'RENEWAL' && attempt.subscriptionId) {
      try {
        await this.fulfillRenewal(attempt.userId, attempt.subscriptionId, payment.id, tokenId);
      } catch (err) {
        log.error('onPaymentCaptured: fulfillRenewal threw — subscription NOT extended', {
          userId: attempt.userId, orderId: payment.order_id, err,
        });
      }
    }

    await prisma.paymentAttempt.update({
      where: { razorpayOrderId: payment.order_id },
      data: {
        status:            'SUCCESS',
        razorpayPaymentId: payment.id,
        razorpayTokenId:   tokenId,
        rawWebhook:        payment,
      },
    });

    log.info('onPaymentCaptured: complete', { userId: attempt.userId, orderId: payment.order_id, kind: attempt.kind });
  }

  // ─── payment.failed ───────────────────────────────────────────────────────
  private async onPaymentFailed(payment: any): Promise<void> {
    if (!payment?.order_id) return;

    const attempt = await prisma.paymentAttempt.findUnique({ where: { razorpayOrderId: payment.order_id } });
    if (!attempt || attempt.status !== 'PENDING') return;

    log.warn('onPaymentFailed', {
      userId: attempt.userId, orderId: payment.order_id, kind: attempt.kind,
      errorCode: payment.error_code, errorDescription: payment.error_description,
    });

    await prisma.paymentAttempt.update({
      where: { razorpayOrderId: payment.order_id },
      data: {
        status:           'FAILED',
        errorCode:        payment.error_code ?? null,
        errorDescription: payment.error_description ?? null,
        rawWebhook:       payment,
      },
    });

    if (attempt.kind === 'RENEWAL' && attempt.subscriptionId) {
      const sub = await prisma.subscription.update({
        where: { id: attempt.subscriptionId },
        data:  { renewalFailureCount: { increment: 1 } },
      });

      if (sub.renewalFailureCount >= 3) {
        await prisma.subscription.update({
          where: { id: sub.id },
          data:  { status: 'EXPIRED', isAutopayEnabled: false },
        });
        oneSignal
          .sendToUser(sub.userId, '⚠️ Subscription Expired',
            'Your autopay renewal failed too many times. Resubscribe to keep enjoying your discounts.',
            'subscription_expired')
          .catch((err) => log.warn('onPaymentFailed: push notification failed (non-fatal)', { userId: sub.userId, err }));
      }
    }
  }

  // ─── token.confirmed — best-effort true-up if the subscription already exists ──
  private async onTokenConfirmed(token: any): Promise<void> {
    if (!token?.id || !token?.customer_id) return;

    log.info('onTokenConfirmed', { tokenId: token.id, customerId: token.customer_id });

    const user = await prisma.user.findFirst({ where: { razorpayCustomerId: token.customer_id } });
    if (!user) return;

    await prisma.subscription.updateMany({
      where: { userId: user.id },
      data: {
        razorpayTokenId:  token.id,
        mandateMaxAmount: token.max_amount ?? undefined,
        mandateExpiresAt: token.expired_at ? new Date(token.expired_at * 1000) : undefined,
      },
    });
  }

  // ─── token.cancelled / .paused / .rejected — mandate no longer usable ───
  private async onTokenRevoked(token: any): Promise<void> {
    if (!token?.id) return;

    log.warn('onTokenRevoked', { tokenId: token.id });

    const sub = await prisma.subscription.findFirst({ where: { razorpayTokenId: token.id } });
    if (!sub) return;

    await prisma.subscription.update({
      where: { id: sub.id },
      data:  { isAutopayEnabled: false },
    });

    oneSignal
      .sendToUser(sub.userId, '🔁 Autopay Disabled',
        'Your UPI autopay mandate was cancelled. Renew manually before your book expires, or re-enable autopay in the app.',
        'autopay_revoked')
      .catch((err) => log.warn('onTokenRevoked: push notification failed (non-fatal)', { userId: sub.userId, err }));
  }

  // ─── Atomic Subscription Fulfillment (first purchase / mandate registration) ──
  private async fulfillSubscription(
    userId: string,
    razorpayPaymentId: string,
    razorpayTokenId: string | null,
  ): Promise<void> {
    log.info('fulfillSubscription: start', { userId, razorpayPaymentId });

    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      log.error('fulfillSubscription: user not found — cannot fulfil', { userId });
      return;
    }

    const [validityDaySetting, coinsSetting] = await Promise.all([
      prisma.appSetting.findUnique({ where: { key: 'book_validity_days' } }),
      prisma.appSetting.findUnique({ where: { key: 'coins_per_subscription' } }),
    ]);
    const validityDays = validityDaySetting ? parseInt(validityDaySetting.value) : 365;
    const coinsToAward = coinsSetting   ? parseInt(coinsSetting.value)   : 50;

    if (!validityDaySetting) log.warn('fulfillSubscription: book_validity_days not set in AppSetting, using default 365', { userId });
    if (!coinsSetting)       log.warn('fulfillSubscription: coins_per_subscription not set in AppSetting, using default 50', { userId });

    const baseCoupons = user.cityId
      ? await prisma.coupon.findMany({
          where: { isBaseCoupon: true, status: 'ACTIVE', seller: { cityId: user.cityId } },
        })
      : [];

    if (!user.cityId) {
      log.warn('fulfillSubscription: user has no cityId — coupon book will have 0 base coupons', { userId });
    } else {
      log.info('fulfillSubscription: base coupons fetched', { userId, cityId: user.cityId, count: baseCoupons.length });
    }

    const now = new Date();
    const endDate = new Date(now);
    endDate.setDate(endDate.getDate() + validityDays);
    const mandateExpiresAt = new Date(now);
    mandateExpiresAt.setFullYear(mandateExpiresAt.getFullYear() + env.RAZORPAY_MANDATE_YEARS);

    try {
      await prisma.$transaction(async (tx) => {
        const subscription = await tx.subscription.upsert({
          where:  { userId },
          create: {
            userId, startDate: now, endDate, status: 'ACTIVE',
            razorpayPaymentId, razorpayTokenId,
            mandateMaxAmount: env.RAZORPAY_MANDATE_MAX_AMOUNT, mandateExpiresAt,
            isAutopayEnabled: true,
          },
          update: {
            startDate: now, endDate, status: 'ACTIVE',
            razorpayPaymentId, razorpayTokenId,
            mandateMaxAmount: env.RAZORPAY_MANDATE_MAX_AMOUNT, mandateExpiresAt,
            isAutopayEnabled: true, renewalFailureCount: 0,
          },
        });

        const couponBook = await tx.couponBook.create({
          data: { subscriptionId: subscription.id, userId, validFrom: now, validUntil: endDate },
        });

        if (baseCoupons.length > 0) {
          await tx.userCoupon.createMany({
            data: baseCoupons.map((c) => ({
              couponBookId:  couponBook.id,
              couponId:      c.id,
              usesRemaining: c.maxUsesPerBook,
              status:        'ACTIVE' as const,
            })),
            skipDuplicates: true,
          });
        }

        await tx.walletTransaction.create({
          data: { userId, type: 'EARNED', amount: coinsToAward, note: 'Subscription bonus coins' },
        });
        await tx.user.update({
          where: { id: userId },
          data:  { coinBalance: { increment: coinsToAward } },
        });

        // ─── Referral Fulfillment ────────────────────────────────────
        const pendingReferral = await tx.referral.findUnique({
          where: { referredId: userId }
        });

        if (pendingReferral && pendingReferral.status === 'PENDING') {
          const [maxLimitSetting, referrerRewardSetting, referredRewardSetting] = await Promise.all([
            tx.appSetting.findUnique({ where: { key: 'max_referrals' } }),
            tx.appSetting.findUnique({ where: { key: 'referrer_coins' } }),
            tx.appSetting.findUnique({ where: { key: 'referred_user_coins' } }),
          ]);

          const maxLimit = maxLimitSetting ? parseInt(maxLimitSetting.value, 10) : 10;
          const referrerReward = referrerRewardSetting ? parseInt(referrerRewardSetting.value, 10) : 5;
          const referredReward = referredRewardSetting ? parseInt(referredRewardSetting.value, 10) : 5;

          const successfulCount = await tx.referral.count({
            where: {
              referrerId: pendingReferral.referrerId,
              status: 'SUCCESSFUL',
            }
          });

          if (successfulCount < maxLimit) {
            await tx.referral.update({
              where: { id: pendingReferral.id },
              data: { status: 'SUCCESSFUL' },
            });

            // Reward referrer
            await tx.walletTransaction.create({
              data: { userId: pendingReferral.referrerId, type: 'EARNED', amount: referrerReward, note: 'Referral Bonus (Referrer)' },
            });
            await tx.user.update({
              where: { id: pendingReferral.referrerId },
              data: { coinBalance: { increment: referrerReward } },
            });

            // Reward referred user
            await tx.walletTransaction.create({
              data: { userId: pendingReferral.referredId, type: 'EARNED', amount: referredReward, note: 'Referral Bonus (Referred)' },
            });
            await tx.user.update({
              where: { id: pendingReferral.referredId },
              data: { coinBalance: { increment: referredReward } },
            });
          }
        }
      });
    } catch (err) {
      log.error('fulfillSubscription: DB transaction failed', { userId, razorpayPaymentId, err });
      throw err;
    }

    log.info('fulfillSubscription: complete', { userId, razorpayPaymentId, validityDays, coinsToAward, endDate });

    oneSignal
      .sendToUser(userId, '🪙 Coins Credited!', `${coinsToAward} coins have been added to your wallet.`, 'coins_credited')
      .catch((err) => log.warn('fulfillSubscription: coins push notification failed (non-fatal)', { userId, err }));
  }

  // ─── Renewal Fulfillment (recurring debit success) ──────────────────────
  private async fulfillRenewal(
    userId: string,
    subscriptionId: string,
    razorpayPaymentId: string,
    razorpayTokenId: string | null,
  ): Promise<void> {
    log.info('fulfillRenewal: start', { userId, subscriptionId, razorpayPaymentId });

    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      log.error('fulfillRenewal: user not found — cannot fulfil', { userId });
      return;
    }

    const [validityDaySetting, coinsSetting] = await Promise.all([
      prisma.appSetting.findUnique({ where: { key: 'book_validity_days' } }),
      prisma.appSetting.findUnique({ where: { key: 'coins_per_subscription' } }),
    ]);
    const validityDays = validityDaySetting ? parseInt(validityDaySetting.value) : 365;
    const coinsToAward = coinsSetting   ? parseInt(coinsSetting.value)   : 50;

    const baseCoupons = user.cityId
      ? await prisma.coupon.findMany({
          where: { isBaseCoupon: true, status: 'ACTIVE', seller: { cityId: user.cityId } },
        })
      : [];

    const now = new Date();
    const endDate = new Date(now);
    endDate.setDate(endDate.getDate() + validityDays);

    try {
      await prisma.$transaction(async (tx) => {
        await tx.subscription.update({
          where: { id: subscriptionId },
          data: {
            startDate: now, endDate, status: 'ACTIVE',
            razorpayPaymentId,
            ...(razorpayTokenId ? { razorpayTokenId } : {}),
            lastRenewalAt: now, renewalFailureCount: 0,
          },
        });

        const couponBook = await tx.couponBook.create({
          data: { subscriptionId, userId, validFrom: now, validUntil: endDate },
        });

        if (baseCoupons.length > 0) {
          await tx.userCoupon.createMany({
            data: baseCoupons.map((c) => ({
              couponBookId:  couponBook.id,
              couponId:      c.id,
              usesRemaining: c.maxUsesPerBook,
              status:        'ACTIVE' as const,
            })),
            skipDuplicates: true,
          });
        }

        await tx.walletTransaction.create({
          data: { userId, type: 'EARNED', amount: coinsToAward, note: 'Subscription renewal bonus coins' },
        });
        await tx.user.update({
          where: { id: userId },
          data:  { coinBalance: { increment: coinsToAward } },
        });
      });
    } catch (err) {
      log.error('fulfillRenewal: DB transaction failed', { userId, subscriptionId, razorpayPaymentId, err });
      throw err;
    }

    log.info('fulfillRenewal: complete', { userId, subscriptionId, endDate });

    oneSignal
      .sendToUser(userId, '✅ Subscription Renewed!', 'Your coupon book has been renewed automatically.', 'subscription_renewed')
      .catch((err) => log.warn('fulfillRenewal: push notification failed (non-fatal)', { userId, err }));
  }

  // ─── Cancel Autopay ─────────────────────────────────────────────────────────
  async cancelAutopay(userId: string): Promise<void> {
    log.info('cancelAutopay: start', { userId });

    const [user, subscription] = await Promise.all([
      prisma.user.findUnique({ where: { id: userId } }),
      prisma.subscription.findUnique({ where: { userId } }),
    ]);

    if (!subscription) {
      throw ConflictError('User has no subscription');
    }
    if (!subscription.isAutopayEnabled) {
      throw ConflictError('Autopay is already disabled');
    }

    if (user?.razorpayCustomerId && subscription.razorpayTokenId) {
      try {
        await razorpay.customers.deleteToken(user.razorpayCustomerId, subscription.razorpayTokenId);
        log.info('cancelAutopay: razorpay mandate token deleted', { userId });
      } catch (err) {
        log.error('cancelAutopay: razorpay.customers.deleteToken failed', { userId, err });
        // Fall through — disable locally anyway so the renewal job never fires
        // again for this user, even if the remote call failed.
      }
    } else {
      log.warn('cancelAutopay: no razorpayCustomerId/razorpayTokenId on record — disabling locally only', { userId });
    }

    await prisma.subscription.update({
      where: { id: subscription.id },
      data: { isAutopayEnabled: false },
    });

    log.info('cancelAutopay: complete', { userId });
  }

  // ─── Get Payment History ────────────────────────────────────────────────────
  async getPaymentHistory(userId: string) {
    const subscription = await prisma.subscription.findUnique({
      where: { userId },
      select: {
        status: true,
        startDate: true,
        endDate: true,
        isAutopayEnabled: true,
      },
    });

    const attempts = await prisma.paymentAttempt.findMany({
      where: {
        userId,
        status: 'SUCCESS',
      },
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        razorpayOrderId: true,
        amount: true,
        createdAt: true,
        kind: true,
      },
    });

    return {
      subscription,
      history: attempts,
    };
  }
}
