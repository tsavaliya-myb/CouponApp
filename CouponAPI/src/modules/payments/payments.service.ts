import { prisma } from '../../config/db';
import { redis } from '../../config/redis';
import { env } from '../../config/env';
import { ConflictError } from '../../shared/utils/AppError';
import { verifyPayUWebhookHash, computeHashFromString } from '../../shared/utils/payuHash';
import { oneSignal } from '../notifications/onesignal.service';

export class PaymentService {

  // ─── Initiate PayU Payment (replaces createOrder) ───────────────────────
  async initiatePayment(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ConflictError('User not found');

    const existingSub = await prisma.subscription.findUnique({ where: { userId } });
    if (existingSub?.status === 'ACTIVE') {
      throw ConflictError('User already has an active subscription');
    }

    // Read subscription price from AppSetting (key: subscription_price)
    const priceSetting = await prisma.appSetting.findUnique({
      where: { key: 'subscription_price' },
    });
    const amount = (priceSetting ? parseFloat(priceSetting.value) : 999).toFixed(2);

    // Build unique transaction id
    const txnid = `sub_${userId.slice(0, 8)}_${Date.now()}`;
    const firstname = user.name?.split(' ')[0] || 'Customer';
    const email = user.email || '';
    const phone = (user.phone || '').replace(/^\+91/, '');

    // Mandate date range: today → 30 years (covers indefinite annual renewals)
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

    // Persist a PENDING attempt — durable fallback if Redis TTL expires before webhook arrives
    await prisma.paymentAttempt.create({
      data: { userId, txnid, amount: amount as any, kind: 'MANDATE', status: 'PENDING' },
    });

    // Cache txnid → userId so the webhook can resolve the user (TTL: 48 h covers PayU retry window)
    await redis.set(`payu_txn:${txnid}`, userId, 'EX', 48 * 3600);

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
  // The Flutter SDK calls its generateHash callback with a hashString.
  // We compute SHA512(hashString + salt) so the salt never leaves the server.
  generateHash(hashString: string): string {
    return computeHashFromString(hashString, env.PAYU_SALT);
  }

  // ─── Handle Incoming PayU S2S Webhook ────────────────────────────────────
  /**
   * PayU posts application/x-www-form-urlencoded.
   * We respond 200 immediately (in the controller) and process async here.
   */
  async handleWebhook(body: Record<string, string>): Promise<void> {
    // 1. Verify reverse hash
    if (!verifyPayUWebhookHash(body, env.PAYU_SALT)) {
      console.error('[PayU Webhook] Hash mismatch — rejected', { txnid: body.txnid });
      return;
    }

    const { txnid, mihpayid, status, error_Message } = body;
    // PayU sends the mandate ref under either key depending on product/region
    const authPayUID = body.auth_payuid || body.authPayUID || '';

    // 2. Idempotency: skip if mihpayid already processed (48 h window)
    const idKey = `payu_processed:${mihpayid}`;
    if (await redis.get(idKey)) {
      console.log(`[PayU Webhook] ${mihpayid} already processed. Skipping.`);
      return;
    }

    // 3. Resolve userId — Redis first, PaymentAttempt table as fallback for late webhooks
    const userId =
      (await redis.get(`payu_txn:${txnid}`)) ??
      (await prisma.paymentAttempt.findUnique({ where: { txnid } }))?.userId;
    if (!userId) {
      console.error('[PayU Webhook] Unknown txnid — cannot resolve user', { txnid });
      return;
    }

    if (status === 'success') {
      // 4a. Fulfill subscription atomically
      await this.fulfillSubscription(userId, mihpayid, authPayUID);

      // 4b. Record success on the attempt
      await prisma.paymentAttempt.update({
        where: { txnid },
        data: {
          status:        'SUCCESS',
          payuPaymentId: mihpayid,
          authPayUID,
          rawWebhook:    body as any,
        },
      });

      oneSignal
        .sendToUser(userId, '🎉 Subscription Activated!', 'Your coupon book is now active. Enjoy your discounts!', 'subscription_success')
        .catch(() => {});

      console.log(`[PayU Webhook] Subscription fulfilled for user ${userId}, mihpayid ${mihpayid}`);
    } else {
      // 4c. Record failure so support can debug without sifting through logs
      await prisma.paymentAttempt.update({
        where: { txnid },
        data: {
          status:       'FAILED',
          errorMessage: error_Message,
          rawWebhook:   body as any,
        },
      });

      console.log(`[PayU Webhook] Non-success status: ${status}`, { txnid, error_Message });
    }

    // 5. Mark mihpayid as processed (idempotency guard for PayU retries)
    await redis.set(idKey, '1', 'EX', 48 * 3600);
  }

  // ─── Atomic Subscription Fulfillment ────────────────────────────────────
  private async fulfillSubscription(
    userId: string,
    payuPaymentId: string,
    authPayUID: string,
  ): Promise<void> {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      console.error(`[fulfillSubscription] User ${userId} not found`);
      return;
    }

    // Read AppSettings
    const [validityDaySetting, coinsSetting] = await Promise.all([
      prisma.appSetting.findUnique({ where: { key: 'book_validity_days' } }),
      prisma.appSetting.findUnique({ where: { key: 'coins_per_subscription' } }),
    ]);
    const validityDays = validityDaySetting ? parseInt(validityDaySetting.value) : 365;
    const coinsToAward = coinsSetting ? parseInt(coinsSetting.value) : 50;

    // Fetch base coupons for the user's city
    const baseCoupons = user.cityId
      ? await prisma.coupon.findMany({
          where: {
            isBaseCoupon: true,
            status:       'ACTIVE',
            seller: { cityId: user.cityId },
          },
        })
      : [];

    const now = new Date();
    const endDate = new Date(now);
    endDate.setDate(endDate.getDate() + validityDays);

    await prisma.$transaction(async (tx) => {
      // 1. Create or renew Subscription (stores PayU IDs)
      const subscription = await tx.subscription.upsert({
        where:  { userId },
        create: {
          userId,
          startDate:     now,
          endDate,
          status:        'ACTIVE',
          payuPaymentId,
          authPayUID,
        },
        update: {
          startDate:     now,
          endDate,
          status:        'ACTIVE',
          payuPaymentId,
          authPayUID,
        },
      });

      // 2. Create CouponBook
      const couponBook = await tx.couponBook.create({
        data: {
          subscriptionId: subscription.id,
          userId,
          validFrom:      now,
          validUntil:     endDate,
        },
      });

      // 3. Seed UserCoupons from base coupons
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

      // 4. Award coins
      await tx.walletTransaction.create({
        data: {
          userId,
          type:   'EARNED',
          amount: coinsToAward,
          note:   'Subscription bonus coins',
        },
      });
      await tx.user.update({
        where: { id: userId },
        data:  { coinBalance: { increment: coinsToAward } },
      });
    });

    oneSignal
      .sendToUser(userId, '🪙 Coins Credited!', `${coinsToAward} coins have been added to your wallet.`, 'coins_credited')
      .catch(() => {});
  }
}
