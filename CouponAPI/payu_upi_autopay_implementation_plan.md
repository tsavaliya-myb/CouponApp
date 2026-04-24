# PayU + UPI Autopay Implementation Plan

Replaces Razorpay with PayU's UPI Autopay (Standing Instructions) for recurring subscription payments.

---

## Architecture Flow

```
User -> Flutter: Taps "Buy Subscription"
Flutter -> Backend: POST /api/v1/payments/initiate
Backend -> Backend: Generate txnid + SHA-512 hash
Backend -> Flutter: { txnid, hash, amount, key, si_details }
Flutter -> PayU SDK: Open CheckoutPro with si_details
User -> PayU App: Authorizes UPI Mandate (MPIN)
PayU App -> PayU SDK: Mandate Registered + authPayUID
PayU -> Backend: POST /api/v1/payments/webhook (S2S urlencoded)
Backend -> Backend: Verify reverse hash + fulfil subscription
PayU <- Backend: 200 OK
Flutter -> Backend: GET /api/v1/users/me
Flutter <- Backend: status: ACTIVE
User <- Flutter: Success screen
```

---

## Phase 1: Account Setup

1. Register at [PayU Dashboard](https://onboarding.payu.in)
2. Request UPI Autopay (Standing Instructions) activation from KAM
3. Note: **Merchant Key**, **Merchant Salt**, **Merchant ID**
4. Configure S2S Webhook URL: `https://yourdomain.com/api/v1/payments/webhook`
5. Download PayU UPI Simulator APK for sandbox testing

---

## Phase 2: Backend (`CouponAPI`)

### 2.1 `.env` — Replace Razorpay vars

```env
# Remove RAZORPAY_* lines, add:
PAYU_KEY=your_merchant_key
PAYU_SALT=your_merchant_salt
PAYU_MERCHANT_ID=your_merchant_id
PAYU_ENV=test
```

### 2.2 `src/config/env.ts`

Remove `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`, `RAZORPAY_WEBHOOK_SECRET`.

Add:

```typescript
PAYU_KEY:         str({ default: '' }),
PAYU_SALT:        str({ default: '' }),
PAYU_MERCHANT_ID: str({ default: '' }),
PAYU_ENV:         str({ choices: ['test', 'production'], default: 'test' }),
```

### 2.3 CREATE `src/config/payu.ts`

```typescript
import { env } from './env';

export const payuConfig = {
  key:     env.PAYU_KEY,
  salt:    env.PAYU_SALT,
  baseUrl: env.PAYU_ENV === 'production'
    ? 'https://secure.payu.in'
    : 'https://test.payu.in',
};
```

### 2.4 CREATE `src/shared/utils/payuHash.ts`

**Request hash:** `key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||SALT`

**Webhook reverse hash:** `SALT|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key`

```typescript
import crypto from 'crypto';

interface HashParams {
  txnid: string; amount: string; productinfo: string;
  firstname: string; email: string;
  udf1?: string; udf2?: string; udf3?: string; udf4?: string; udf5?: string;
}

export function generatePayUHash(p: HashParams, key: string, salt: string): string {
  const { txnid, amount, productinfo, firstname, email } = p;
  const u1=p.udf1||'', u2=p.udf2||'', u3=p.udf3||'', u4=p.udf4||'', u5=p.udf5||'';
  const str = `${key}|${txnid}|${amount}|${productinfo}|${firstname}|${email}|${u1}|${u2}|${u3}|${u4}|${u5}||||||${salt}`;
  return crypto.createHash('sha512').update(str).digest('hex');
}

export function verifyPayUWebhookHash(body: Record<string, string>, salt: string): boolean {
  const received = body.hash;
  const { status='', udf5='', udf4='', udf3='', udf2='', udf1='',
    email='', firstname='', productinfo='', amount='', txnid='', key='' } = body;
  const str = `${salt}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;
  const computed = crypto.createHash('sha512').update(str).digest('hex');
  return computed.toLowerCase() === received?.toLowerCase();
}
```

### 2.5 REWRITE `src/modules/payments/payments.service.ts`

**`initiatePayment(userId)`** — replaces `createOrder()`:

```typescript
async initiatePayment(userId: string) {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) throw ConflictError('User not found');

  const existingSub = await prisma.subscription.findUnique({ where: { userId } });
  if (existingSub?.status === 'ACTIVE') throw ConflictError('Already subscribed');

  const priceSetting = await prisma.appSetting.findUnique({ where: { key: 'subscription_price' } });
  const amount = (priceSetting ? parseFloat(priceSetting.value) : 999).toFixed(2);

  const txnid = `sub_${userId.slice(0,8)}_${Date.now()}`;
  const firstname = user.name?.split(' ')[0] || 'Customer';
  const email = user.email || '';

  const now = new Date();
  const end = new Date(now); end.setFullYear(end.getFullYear() + 1);
  const fmt = (d: Date) => d.toISOString().split('T')[0];

  const hash = generatePayUHash(
    { txnid, amount, productinfo: 'CouponApp Premium', firstname, email },
    env.PAYU_KEY, env.PAYU_SALT
  );

  // Cache txnid -> userId for webhook resolution (TTL: 1h)
  await redis.set(`payu_txn:${txnid}`, userId, 'EX', 3600);

  return {
    key: env.PAYU_KEY, txnid, amount,
    productinfo: 'CouponApp Premium',
    firstname, email, phone: user.phone, hash,
    env: env.PAYU_ENV,
    si_details: {
      billingAmount: amount, billingCurrency: 'INR',
      billingCycle: 'MONTHLY', billingRule: 'MAX',
      remarks: 'CouponApp Monthly Subscription',
      mandateStartDate: fmt(now), mandateEndDate: fmt(end),
    },
  };
}
```

**`handleWebhook(body)`**:

```typescript
async handleWebhook(body: Record<string, string>): Promise<void> {
  if (!verifyPayUWebhookHash(body, env.PAYU_SALT)) {
    console.error('[PayU Webhook] Hash mismatch — rejected'); return;
  }
  if (body.status !== 'success') {
    console.log(`[PayU Webhook] Non-success: ${body.status}`); return;
  }

  const { txnid, mihpayid, auth_payuid } = body;
  const idKey = `payu_processed:${mihpayid}`;
  if (await redis.get(idKey)) return; // idempotency

  const userId = await redis.get(`payu_txn:${txnid}`);
  if (!userId) { console.error('[PayU Webhook] Unknown txnid'); return; }

  await this.fulfillSubscription(userId, mihpayid, auth_payuid || '');
  await redis.set(idKey, '1', 'EX', 48 * 3600);

  oneSignal.sendToUser(userId, '🎉 Subscription Activated!',
    'Your coupon book is now active!', 'subscription_success').catch(()=>{});
}
```

**`fulfillSubscription(userId, payuPaymentId, authPayUID)`** — same atomic `prisma.$transaction` as Razorpay version, but store `payuPaymentId` and `authPayUID` in `Subscription`.

### 2.6 REWRITE `src/modules/payments/payments.controller.ts`

```typescript
initiatePayment = async (req, res, next) => {
  try {
    const result = await paymentService.initiatePayment(req.user!.userId);
    sendSuccess(res, result, 201);
  } catch (err) { next(err); }
};

// PayU posts urlencoded body; respond 200 immediately
webhook = async (req, res, next) => {
  res.status(200).json({ status: 'ok' });
  paymentService.handleWebhook(req.body).catch(console.error);
};
```

### 2.7 REWRITE `src/modules/payments/payments.routes.ts`

```typescript
import express from 'express';
// ...

router.post('/initiate', authenticate, ctrl.initiatePayment);

// IMPORTANT: PayU sends application/x-www-form-urlencoded NOT JSON
router.post('/webhook',
  express.urlencoded({ extended: true }),
  ctrl.webhook
);
```

### 2.8 Prisma Schema Update

```prisma
model Subscription {
  id            String   @id @default(cuid())
  userId        String   @unique
  status        String   @default("ACTIVE")
  startDate     DateTime
  endDate       DateTime
  payuPaymentId String?  // mihpayid from PayU webhook
  authPayUID    String?  // mandate ref for si_transaction recurring debits
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt
  user          User     @relation(fields: [userId], references: [id])
}
```

Run: `npx prisma migrate dev --name replace_razorpay_with_payu`

### 2.9 Cleanup

- DELETE `src/config/razorpay.ts`
- DELETE `src/shared/middlewares/razorpayWebhook.middleware.ts`
- Run: `npm uninstall razorpay`

---

## Phase 3: Flutter App (`CouponCustomer`)

### 3.1 `pubspec.yaml`

```yaml
dependencies:
  # Remove: razorpay_flutter: ^1.3.6
  payu_checkoutpro_flutter: ^3.0.0  # Add
```

### 3.2 Android Setup

`android/app/build.gradle`:
```groovy
defaultConfig { minSdkVersion 21 }
```

`AndroidManifest.xml` — add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="upi"/>
  </intent>
</queries>
```

### 3.3 `lib/features/payment/data/payment_repository.dart`

```dart
Future<Map<String, dynamic>> initiatePayment() async {
  final response = await _dio.post('/api/v1/payments/initiate');
  return response.data['data'] as Map<String, dynamic>;
}
```

### 3.4 CREATE `lib/core/services/payu_service.dart`

```dart
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUPaymentParamKey.dart';
import 'package:payu_checkoutpro_flutter/PayUSIParamsKeys.dart';

class PayUService implements PayUCheckoutProProtocol {
  PayUCheckoutPro? _payU;
  Function(String)? onSuccess;
  Function(String)? onFailure;

  void initialize(BuildContext context) {
    _payU = PayUCheckoutPro(context, this);
  }

  void openCheckout(Map<String, dynamic> params) {
    final si = params['si_details'] as Map<String, dynamic>;

    _payU?.openCheckoutScreen({
      PayUPaymentParamKey.key: params['key'],
      PayUPaymentParamKey.amount: params['amount'],
      PayUPaymentParamKey.productInfo: params['productinfo'],
      PayUPaymentParamKey.firstName: params['firstname'],
      PayUPaymentParamKey.email: params['email'],
      PayUPaymentParamKey.phone: params['phone'],
      PayUPaymentParamKey.txnId: params['txnid'],
      PayUPaymentParamKey.hash: params['hash'],
      PayUPaymentParamKey.isProduction: params['env'] == 'production',
      PayUPaymentParamKey.siParams: {
        PayUSIParamsKeys.isPreAuthTxn: true,
        PayUSIParamsKeys.paymentStartDate: si['mandateStartDate'],
        PayUSIParamsKeys.paymentEndDate: si['mandateEndDate'],
      },
    });
  }

  void dispose() => _payU?.terminateCheckout();

  @override
  void onPaymentSuccess(dynamic response) =>
      onSuccess?.call(response?['mihpayid'] ?? '');

  @override
  void onPaymentFailure(dynamic response) =>
      onFailure?.call(response?['error_Message'] ?? 'Payment failed');

  @override
  void onPaymentCancel(dynamic? isTxnInitiated) =>
      onFailure?.call('Cancelled by user');

  @override
  void onError(dynamic response) =>
      onFailure?.call(response?.toString() ?? 'Unknown error');
}
```

### 3.5 `lib/features/payment/presentation/payment_controller.dart`

```dart
Future<void> startPaymentFlow(BuildContext context) async {
  state = const AsyncLoading();
  try {
    final params = await ref.read(paymentRepositoryProvider).initiatePayment();
    final service = ref.read(payuServiceProvider);
    service.initialize(context);

    service.onSuccess = (_) async {
      // Webhook fulfils subscription; poll profile after short delay
      await Future.delayed(const Duration(seconds: 3));
      await ref.read(profileControllerProvider.notifier).refresh();
      state = const AsyncData(null);
      if (context.mounted) context.go('/subscription-success');
    };

    service.onFailure = (err) =>
        state = AsyncError(err, StackTrace.current);

    service.openCheckout(params);
  } catch (e, st) {
    state = AsyncError(e, st);
  }
}
```

---

## Phase 4: Future Recurring Debits (si_transaction)

After mandate is registered, renew monthly without user interaction (server-side cron):

```typescript
// Hash: key|si_transaction|var1|SALT
async triggerRecurringDebit(userId: string) {
  const sub = await prisma.subscription.findUnique({ where: { userId } });
  const user = await prisma.user.findUnique({ where: { id: userId } });
  const txnid = `renew_${userId.slice(0,8)}_${Date.now()}`;

  const var1 = JSON.stringify({
    amount: '999.00', txnid,
    authpayuid: sub!.authPayUID,
    email: user!.email, phone: user!.phone,
  });

  const hashStr = `${env.PAYU_KEY}|si_transaction|${var1}|${env.PAYU_SALT}`;
  const hash = crypto.createHash('sha512').update(hashStr).digest('hex');

  await axios.post(`${payuConfig.baseUrl}/merchant/postservice.php?form=2`,
    new URLSearchParams({ key: env.PAYU_KEY, command: 'si_transaction', var1, hash })
  );
}
```

> Schedule 24h after sending the mandatory pre-debit notification (RBI compliance).

---

## Phase 5: Pre-Debit Notification (RBI Compliance)

RBI mandates notification **at least 24 hours** before any auto-debit:

```typescript
async sendPreDebitNotification(userId: string, amount: string, debitDate: string) {
  await oneSignal.sendToUser(
    userId, '📅 Upcoming Auto-Debit',
    `₹${amount} will be debited on ${debitDate} for CouponApp subscription.`,
    'pre_debit_alert'
  );
  // Also send SMS via MSG91
}
```

---

## Phase 6: Testing

### Sandbox Credentials

| Field | Value |
|-------|-------|
| Merchant Key | `gtKFFx` |
| Merchant Salt | `eCwWELxi` |
| Test UPI VPA | `anything@payu` |
| SDK env flag | `isProduction: false` |
| API endpoint | `https://test.payu.in` |

### Test Checklist

- [ ] `POST /initiate` returns valid hash (verify with PayU hash tool)
- [ ] Flutter SDK opens PayU checkout with UPI Autopay tab
- [ ] Mandate registration completes with test VPA
- [ ] S2S webhook fires to `/api/v1/payments/webhook` (urlencoded)
- [ ] Webhook hash verification passes
- [ ] Subscription + CouponBook + Coins granted atomically
- [ ] `GET /users/me` returns `subscription.status === 'ACTIVE'`
- [ ] Idempotency: duplicate webhooks do NOT double-grant
- [ ] Failure path shows correct error UI in Flutter

---

## File Change Summary

### CouponAPI

| Action | File |
|--------|------|
| DELETE | `src/config/razorpay.ts` |
| DELETE | `src/shared/middlewares/razorpayWebhook.middleware.ts` |
| CREATE | `src/config/payu.ts` |
| CREATE | `src/shared/utils/payuHash.ts` |
| MODIFY | `src/config/env.ts` |
| MODIFY | `src/modules/payments/payments.service.ts` |
| MODIFY | `src/modules/payments/payments.controller.ts` |
| MODIFY | `src/modules/payments/payments.routes.ts` |
| MODIFY | `prisma/schema.prisma` |
| MODIFY | `.env` |

### CouponCustomer (Flutter)

| Action | File |
|--------|------|
| MODIFY | `pubspec.yaml` |
| MODIFY | `android/app/build.gradle` |
| MODIFY | `android/app/src/main/AndroidManifest.xml` |
| MODIFY | `lib/features/payment/data/payment_repository.dart` |
| CREATE | `lib/core/services/payu_service.dart` |
| DELETE | `lib/core/services/razorpay_service.dart` |
| MODIFY | `lib/features/payment/presentation/payment_controller.dart` |
