import { prisma } from '../../config/db';
import { redis } from '../../config/redis';
import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { ConflictError } from '../../shared/utils/AppError';
import { verifyPayUWebhookHash, computeHashFromString } from '../../shared/utils/payuHash';
import { oneSignal } from '../notifications/onesignal.service';

const log = logger.child({ module: 'PaymentService' });

export class PaymentService {

  // ─── Initiate PayU Payment ───────────────────────────────────────────────
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
    const amount = (priceSetting ? parseFloat(priceSetting.value) : 999).toFixed(2);

    const txnid = `sub_${userId.slice(0, 8)}_${Date.now()}`;
    const firstname = user.name?.split(' ')[0] || 'Customer';
    const email = user.email || '';
    const phone = (user.phone || '').replace(/^\+91/, '');

    const now = new Date();
    const end = new Date(now);
    end.setFullYear(end.getFullYear() + 30);
    const fmt = (d: Date) => d.toISOString().split('T')[0];

    const siParams = {
      billingAmount:    amount,
      billingCurrency:  'INR',
      billingCycle:     'yearly',
      billingInterval:  1,
      paymentStartDate: fmt(now),
      paymentEndDate:   fmt(end),
      billingRule:      'MAX',
      remarks:          'CouponApp Annual Subscription',
    };

    await prisma.paymentAttempt.create({
      data: { userId, txnid, amount: amount as any, kind: 'MANDATE', status: 'PENDING' },
    });

    await redis.set(`payu_txn:${txnid}`, userId, 'EX', 48 * 3600);

    log.info('initiatePayment: params ready', { userId, txnid, amount });

    return {
      key:            env.PAYU_KEY,
      txnid,
      amount,
      productinfo:    'CouponApp Premium',
      firstname,
      email,
      phone,
      userCredential: '',
      env:            env.PAYU_ENV,
      si_details:     siParams,
    };
  }

  // ─── Server-side Hash Generation for PayU SDK Callback ──────────────────
  generateHash(hashString: string): string {
    log.debug('generateHash: computing hash for SDK callback');
    return computeHashFromString(hashString, env.PAYU_SALT);
  }

  // ─── Handle Incoming PayU S2S Webhook ────────────────────────────────────
  async handleWebhook(body: Record<string, string>): Promise<void> {
    const { txnid, mihpayid, status, error_Message, unmappedstatus } = body;
    const authPayUID = body.auth_payuid || body.authPayUID || '';

    log.info('webhook: received', { txnid, mihpayid, status, unmappedstatus });

    if (!verifyPayUWebhookHash(body, env.PAYU_SALT)) {
      log.error('webhook: hash verification failed — request rejected', { txnid, mihpayid, status });
      return;
    }

    const idKey = `payu_processed:${mihpayid}`;
    if (await redis.get(idKey)) {
      log.warn('webhook: duplicate delivery ignored', { txnid, mihpayid });
      return;
    }

    const userId =
      (await redis.get(`payu_txn:${txnid}`)) ??
      (await prisma.paymentAttempt.findUnique({ where: { txnid } }))?.userId;

    if (!userId) {
      log.error('webhook: could not resolve userId from txnid', { txnid, mihpayid });
      return;
    }

    if (status === 'success') {
      log.info('webhook: payment success — fulfilling subscription', { userId, txnid, mihpayid, authPayUID });

      try {
        await this.fulfillSubscription(userId, mihpayid, authPayUID);
      } catch (err) {
        log.error('webhook: fulfillSubscription threw — subscription NOT activated', {
          userId, txnid, mihpayid, err,
        });
        // Still update the attempt and mark processed so we don't retry fulfillment on duplicate webhooks.
        // Support must manually investigate and fulfil if needed.
      }

      await prisma.paymentAttempt.update({
        where: { txnid },
        data: {
          status:        'SUCCESS',
          payuPaymentId: mihpayid,
          authPayUID,
          rawWebhook:    body as any,
        },
      });

      log.info('webhook: subscription activated', { userId, txnid, mihpayid });

      oneSignal
        .sendToUser(userId, '🎉 Subscription Activated!', 'Your coupon book is now active. Enjoy your discounts!', 'subscription_success')
        .catch((err) => log.warn('webhook: push notification failed (non-fatal)', { userId, err }));

    } else {
      log.warn('webhook: payment not successful', { userId, txnid, mihpayid, status, unmappedstatus, error_Message });

      await prisma.paymentAttempt.update({
        where: { txnid },
        data: {
          status:       'FAILED',
          errorMessage: error_Message,
          rawWebhook:   body as any,
        },
      });
    }

    await redis.set(idKey, '1', 'EX', 48 * 3600);
  }

  // ─── Atomic Subscription Fulfillment ────────────────────────────────────
  private async fulfillSubscription(
    userId: string,
    payuPaymentId: string,
    authPayUID: string,
  ): Promise<void> {
    log.info('fulfillSubscription: start', { userId, payuPaymentId });

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

    try {
      await prisma.$transaction(async (tx) => {
        const subscription = await tx.subscription.upsert({
          where:  { userId },
          create: { userId, startDate: now, endDate, status: 'ACTIVE', payuPaymentId, authPayUID },
          update: { startDate: now, endDate, status: 'ACTIVE', payuPaymentId, authPayUID },
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
      });
    } catch (err) {
      log.error('fulfillSubscription: DB transaction failed', { userId, payuPaymentId, err });
      throw err;
    }

    log.info('fulfillSubscription: complete', { userId, payuPaymentId, validityDays, coinsToAward, endDate });

    oneSignal
      .sendToUser(userId, '🪙 Coins Credited!', `${coinsToAward} coins have been added to your wallet.`, 'coins_credited')
      .catch((err) => log.warn('fulfillSubscription: coins push notification failed (non-fatal)', { userId, err }));
  }
}
