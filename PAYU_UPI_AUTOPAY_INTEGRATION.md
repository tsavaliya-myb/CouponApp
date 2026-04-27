# PayU UPI Intent Autopay — Complete Integration Guide

> Comprehensive implementation reference for `CouponCustomer` (Flutter) + `CouponAPI` (Node/Express).
> Audited against your current code, the [PayU UPI Intent & Collect Autopay (TPV)](https://docs.payu.in/docs/upi-intent-and-collect-autopay-tpv-integration) docs, and the [Flutter CheckoutPro SDK](https://docs.payu.in/docs/flutter-checkoutprosdk-integration-steps) docs.

---

## Table of Contents

1. [What "UPI Intent Autopay" Means](#1-what-upi-intent-autopay-means)
2. [End-to-End Flow](#2-end-to-end-flow)
3. [Issues Found in Your Current Code](#3-issues-found-in-your-current-code)
4. [Fix List — Backend (CouponAPI)](#4-fix-list--backend-couponapi)
5. [Fix List — Mobile (CouponCustomer)](#5-fix-list--mobile-couponcustomer)
6. [Hash Formulas — Single Source of Truth](#6-hash-formulas--single-source-of-truth)
7. [Webhook Contract](#7-webhook-contract)
8. [Recurring Debit (`si_transaction`)](#8-recurring-debit-si_transaction)
9. [RBI Pre-Debit Notification](#9-rbi-pre-debit-notification)
10. [Database Schema](#10-database-schema)
11. [Test Plan](#11-test-plan)
12. [Common Failure Modes (Symptom → Cause → Fix)](#12-common-failure-modes)

---

## 1. What "UPI Intent Autopay" Means

| Term | Meaning |
|---|---|
| **UPI Intent** | One-tap UPI flow that hands off to the user's UPI app (GPay/PhonePe/etc.) via Android Intent. No VPA typing. |
| **Autopay (SI)** | A *Standing Instruction* mandate registered with the user's bank via NPCI. PayU debits on a recurring schedule without re-asking the user (within mandate limits). |
| **TPV** | *Third-Party Verification* — the bank verifies the customer's account before approving the mandate. Required for some merchant categories; optional for most app subscriptions. |
| **Pre-Auth (`isPreAuthTxn`)** | First mandate-registration transaction. Customer authorizes via MPIN; the actual debit may be ₹0 or a tiny amount, and recurring charges happen after. |

**For CouponApp**:
- Use **UPI Intent + Autopay** (not TPV) — you don't need the bank to verify the customer's account number.
- First charge = ₹999 today (mandate registration + immediate first debit).
- Recurring charge = ₹999 every year on subscription expiry, debited via `si_transaction` API without user interaction.
- RBI mandates a pre-debit notification ≥24h before each recurring charge.

---

## 2. End-to-End Flow

```
┌─────────┐                ┌──────────┐                ┌─────────────┐                ┌──────┐
│ User    │                │ Flutter  │                │ Backend     │                │ PayU │
│         │                │ App      │                │ (CouponAPI) │                │      │
└────┬────┘                └────┬─────┘                └──────┬──────┘                └──┬───┘
     │ Tap "Buy Subscription"   │                              │                          │
     ├─────────────────────────>│                              │                          │
     │                          │ POST /payments/initiate      │                          │
     │                          ├─────────────────────────────>│                          │
     │                          │                              │ ─ Build txnid            │
     │                          │                              │ ─ Build siParams         │
     │                          │                              │ ─ Cache txnid→userId     │
     │                          │                              │   (Redis 24h)            │
     │                          │< ─ params (no hash needed) ──┤                          │
     │                          │                              │                          │
     │                          │ openCheckoutScreen({...})    │                          │
     │                          ├──────── PayU SDK ──────────────────────────────────────>│
     │                          │                              │                          │
     │                          │ generateHash(hashString)     │                          │
     │                          │   callback fires             │                          │
     │                          │                              │                          │
     │                          │ POST /payments/generate-hash │                          │
     │                          ├─────────────────────────────>│                          │
     │                          │                              │ SHA512(hashString+salt) │
     │                          │< ──────── { hash } ──────────┤                          │
     │                          │                              │                          │
     │                          │ hashGenerated(...)           │                          │
     │                          ├───────────────────────────────────────────────────────> │
     │                          │                              │                          │
     │ MPIN authorization in    │                              │                          │
     │ UPI app (GPay/PhonePe)   │                              │                          │
     │<──────────── PayU/UPI Intent ─────────────────────────────────────────────────────>│
     │                          │                              │                          │
     │                          │                              │ POST /payments/webhook   │
     │                          │                              │  (form-urlencoded)       │
     │                          │                              │< ────────────────────────┤
     │                          │                              │                          │
     │                          │                              │ ─ verifyReverseHash      │
     │                          │                              │ ─ fulfillSubscription    │
     │                          │                              │   (Subscription +        │
     │                          │                              │    CouponBook +          │
     │                          │                              │    UserCoupons + Coins)  │
     │                          │                              │ ─ store mihpayid +       │
     │                          │                              │   authPayUID for         │
     │                          │                              │   future si_transaction  │
     │                          │                              │                          │
     │                          │ onPaymentSuccess()           │                          │
     │                          │< ─────────────────────────────────────────────────────  │
     │                          │                              │                          │
     │                          │ wait 3s, then refresh        │                          │
     │                          │ profileProvider              │                          │
     │< ─ Subscription ACTIVE ──┤                              │                          │
```

---

## 3. Issues Found in Your Current Code

### 🔴 BLOCKER bugs (will prevent payments from succeeding)

#### B1. Webhook reverse-hash formula is missing `si_details`
[`payuHash.ts:124`](CouponAPI/src/shared/utils/payuHash.ts#L124) uses the **non-SI** reverse formula:
```ts
`${salt}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`
```

PayU docs explicitly state for SI/Autopay:
> `sha512(SALT|si_details|status||||||udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key)`

**Effect**: every SI webhook will fail hash verification → subscription never activates → user is charged but app stays on "loading".

#### B2. `additionalParam` is being abused to send static hashes
[`payments.service.ts:74-77`](CouponAPI/src/modules/payments/payments.service.ts#L74-L77) puts `payment_related_details_for_mobile_sdk`, `vas_for_mobile_sdk`, and `payment` into `additionalParam`. Then [`payu_service.dart:57-58`](CouponCustomer/lib/core/services/payu_service.dart#L57-L58) forwards them as `PayUPaymentParamKey.additionalParam`.

**`additionalParam` is reserved for UDFs** (`udf1..udf5`) and a small set of merchant fields (`merchantAccessKey`, `sourceId`). Putting hashes there means:
- They are **NOT consumed** by the SDK as static hashes (those only flow through the `generateHash` callback).
- They get **POSTed verbatim to PayU's `_payment` endpoint** as form fields, which can produce silent failures or hash-mismatch errors at PayU's side.

#### B3. Pre-computed payment `hash` in `/initiate` response is dead code
[`payments.service.ts:49-54`](CouponAPI/src/modules/payments/payments.service.ts#L49-L54) computes `generateSIPayUHash(...)`. The Flutter side never passes `params['hash']` to the SDK (no `PayUPaymentParamKey.hash` in [`payu_service.dart:43-71`](CouponCustomer/lib/core/services/payu_service.dart#L43-L71)). The SDK uses `generateHash` callback exclusively.

This is wasted computation, but more importantly: if you ever pre-compute the payment hash and the SDK's internally-built `si_details` JSON doesn't byte-match yours (different key order, whitespace, etc.), you're debugging ghosts. Delete the pre-computed hash.

### 🟡 Medium severity

#### M1. `billingCycle: 'yearly'` with 1-year `paymentEndDate` only authorizes ONE charge
[`payments.service.ts:42`](CouponAPI/src/modules/payments/payments.service.ts#L42). With `billingCycle=yearly`, `billingInterval=1`, `paymentEndDate=+1 year`, the mandate covers exactly one yearly charge. After that, the mandate dies and you cannot auto-renew without re-prompting the user.

For an "indefinite annual subscription", set `paymentEndDate` to **5–30 years out**. PayU caps mandates at the bank's policy (commonly 30 years). Use `paymentEndDate = today + 30 years`.

#### M2. `txnid` resolution cache is too short (1 h)
[`payments.service.ts:61`](CouponAPI/src/modules/payments/payments.service.ts#L61). If a webhook is delayed (PayU retries up to 24 h) or the mandate registration takes >1 h (rare but possible with bank validation), Redis loses the `txnid → userId` mapping and the webhook drops the event silently.

**Fix**: persist the pending payment in a `PaymentAttempt` table OR bump Redis TTL to 48 h.

#### M3. `userCredential` set to `key:email` for users with no stored cards
[`payments.service.ts:57`](CouponAPI/src/modules/payments/payments.service.ts#L57). This activates the SDK's "stored cards" feature, which requires extra static hashes to be valid. For UPI Autopay you don't need it. Either:
- Pass `userCredential: ''` (recommended for UPI-only), OR
- Pass `key:userId` (stable across email changes) and properly support the saved-cards static hashes.

#### M4. `phone` may carry `+91` prefix
PayU expects 10-digit Indian phone numbers. If `user.phone` is stored as `+919876543210`, strip the `+91` before passing it.

#### M5. Webhook does not surface `error_Message` / `unmappedstatus` for failed mandates
[`payments.service.ts:111-114`](CouponAPI/src/modules/payments/payments.service.ts#L111-L114) silently logs and exits when status is non-success. You should at least record a `PaymentAttempt` row with `status='FAILED'` so support can debug.

#### M6. No `si_transaction` recurring debit job
The whole point of Autopay is that *renewal* doesn't require user interaction. There is currently no BullMQ job to call `si_transaction` when a subscription nears expiry. Without this, your Autopay mandate sits idle and the user has to repurchase manually anyway.

#### M7. No RBI pre-debit notification
RBI mandates a notification ≥24 h before each recurring debit. Not implemented.

### 🟢 Minor / cleanup

- **N1**. [`payments.swagger.ts`](CouponAPI/src/modules/payments/payments.swagger.ts) is still describing the **Razorpay** routes (`/payments/create-order`, `x-razorpay-signature`). Rewrite for PayU.
- **N2**. [`payments.validator.ts`](CouponAPI/src/modules/payments/payments.validator.ts) likely still has Razorpay-shaped schemas — review and replace.
- **N3**. The `merchantResponseTimeout: 10` you added is good for slow cold-starts, but consider warming the API or moving to a faster host. 10s is the SDK ceiling — anything longer and the SDK aborts the transaction.
- **N4**. The `productinfo` `'CouponApp Premium'` is fine for plain subscriptions, but for anything itemized you'll need the JSON form (`paymentParts`, `paymentIdentifier`).

---

## 4. Fix List — Backend (`CouponAPI`)

### 4.1 Fix the webhook reverse-hash (BLOCKER B1)

**File**: [`src/shared/utils/payuHash.ts`](CouponAPI/src/shared/utils/payuHash.ts)

Replace `verifyPayUWebhookHash` with a version that handles BOTH non-SI and SI flows. PayU sends back `si_details` as a string in the webhook for SI transactions; you must include it when present.

```ts
/**
 * Verify the reverse hash sent by PayU in the S2S webhook.
 *
 * Non-SI: SHA512(SALT|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key)
 * SI:     SHA512(SALT|si_details|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key)
 *
 * If `additionalCharges` is present, it is prepended:
 * SHA512(additionalCharges|<above>)
 */
export function verifyPayUWebhookHash(
  body: Record<string, string>,
  salt: string,
): boolean {
  const received = body.hash;
  if (!received) return false;

  const {
    status = '', udf5 = '', udf4 = '', udf3 = '', udf2 = '', udf1 = '',
    email = '', firstname = '', productinfo = '', amount = '', txnid = '', key = '',
    si_details = '', additionalCharges = '',
  } = body;

  // Build the core (reverse) section first
  const core = `${salt}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;

  // Two candidate strings, depending on whether PayU sent si_details
  const withSi    = `${salt}|${si_details}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;
  const candidates = si_details ? [withSi, core] : [core];

  // additionalCharges variant
  const withAddl = candidates.map(s => `${additionalCharges}|${s}`);
  const all = additionalCharges ? [...withAddl, ...candidates] : candidates;

  return all.some(s =>
    crypto.createHash('sha512').update(s).digest('hex').toLowerCase() === received.toLowerCase(),
  );
}
```

> Trying multiple candidates is defensive: PayU's webhook payload varies by product/region, and matching any valid form is safer than guessing one.

### 4.2 Drop the dead-code pre-computed payment hash (BLOCKER B3)

**File**: [`src/modules/payments/payments.service.ts`](CouponAPI/src/modules/payments/payments.service.ts)

Remove the `generateSIPayUHash(...)` call and the `hash` field in the response. The Flutter SDK doesn't use it — `generateHash` callback handles all hashes dynamically.

```ts
// DELETE these lines:
// const hash = generateSIPayUHash(...);
// const userCredential = `${env.PAYU_KEY}:${email}`;
// const staticHashes = generateMobileSDKStaticHashes(env.PAYU_KEY, userCredential, env.PAYU_SALT);
// additionalParam: { ...staticHashes, payment: hash },

return {
  key:         env.PAYU_KEY,
  txnid,
  amount,
  productinfo: 'CouponApp Premium',
  firstname,
  email,
  phone:       user.phone.replace(/^\+91/, ''),  // strip +91 (M4)
  userCredential: '',                            // empty for UPI-only (M3)
  env:         env.PAYU_ENV,
  si_details:  siParams,                         // pass cleanly to Flutter
};
```

### 4.3 Strip `additionalParam` hash usage (BLOCKER B2)

Already covered above — the response no longer carries `additionalParam` for hashes. Mobile side fix in §5.2.

### 4.4 Fix mandate `paymentEndDate` (M1)

```ts
const now = new Date();
const end = new Date(now);
end.setFullYear(end.getFullYear() + 30);   // mandate valid 30 years
const fmt = (d: Date) => d.toISOString().split('T')[0];

const siParams = {
  billingAmount:    amount,                  // "999.00"
  billingCurrency:  'INR',
  billingCycle:     'yearly',                // lowercase per docs
  billingInterval:  1,
  paymentStartDate: fmt(now),
  paymentEndDate:   fmt(end),
  billingRule:      'MAX',                   // PayU may charge ≤ billingAmount
  remarks:          'CouponApp Annual Subscription',
};
```

### 4.5 Bump txnid Redis TTL + add a `PaymentAttempt` table (M2)

```ts
await redis.set(`payu_txn:${txnid}`, userId, 'EX', 48 * 3600);
```

…and add a Prisma model so failed/pending attempts have a durable record:

```prisma
enum PaymentAttemptStatus { PENDING SUCCESS FAILED }

model PaymentAttempt {
  id            String   @id @default(uuid())
  userId        String
  txnid         String   @unique
  amount        Decimal  @db.Decimal(10,2)
  status        PaymentAttemptStatus @default(PENDING)
  payuPaymentId String?  // mihpayid
  authPayUID    String?  // mandate ref
  errorCode     String?
  errorMessage  String?
  rawWebhook    Json?    // full body for debugging
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  user          User     @relation(fields: [userId], references: [id])

  @@index([userId])
}
```

In `initiatePayment`, create a row with `status=PENDING`. In the webhook, update it.

### 4.6 Webhook: persist failures, idempotent on `mihpayid`

```ts
async handleWebhook(body: Record<string, string>): Promise<void> {
  if (!verifyPayUWebhookHash(body, env.PAYU_SALT)) {
    console.error('[PayU Webhook] Hash mismatch — rejected', { txnid: body.txnid });
    return;
  }

  const { txnid, mihpayid, status, error_Message, addedon } = body;
  const authPayUID = body.auth_payuid || body.authPayUID || '';

  const idKey = `payu_processed:${mihpayid}`;
  if (await redis.get(idKey)) return;

  const userId = await redis.get(`payu_txn:${txnid}`)
    ?? (await prisma.paymentAttempt.findUnique({ where: { txnid } }))?.userId;
  if (!userId) {
    console.error('[PayU Webhook] Unknown txnid', { txnid });
    return;
  }

  if (status === 'success') {
    await this.fulfillSubscription(userId, mihpayid, authPayUID);
    await prisma.paymentAttempt.update({
      where: { txnid },
      data:  { status: 'SUCCESS', payuPaymentId: mihpayid, authPayUID, rawWebhook: body },
    });
    oneSignal.sendToUser(userId, '🎉 Subscription Activated!',
      'Your coupon book is now active!', 'subscription_success').catch(()=>{});
  } else {
    await prisma.paymentAttempt.update({
      where: { txnid },
      data:  { status: 'FAILED', errorMessage: error_Message, rawWebhook: body },
    });
  }

  await redis.set(idKey, '1', 'EX', 48 * 3600);
}
```

### 4.7 Replace Razorpay-era Swagger doc (N1)

Replace [`payments.swagger.ts`](CouponAPI/src/modules/payments/payments.swagger.ts) — the current contents document `/payments/create-order` and `x-razorpay-signature`, both irrelevant.

### 4.8 Validator cleanup (N2)

Audit [`payments.validator.ts`](CouponAPI/src/modules/payments/payments.validator.ts) and replace any `createOrderResponseSchema` with the new `initiatePaymentResponseSchema` matching the §4.2 response shape.

---

## 5. Fix List — Mobile (`CouponCustomer`)

### 5.1 Stop forwarding `additionalParam` from the backend (BLOCKER B2)

**File**: [`lib/core/services/payu_service.dart`](CouponCustomer/lib/core/services/payu_service.dart)

```dart
// DELETE:
// final additionalParam = <String, dynamic>{
//   ...(params['additionalParam'] as Map<String, dynamic>? ?? {}),
// };
// if (additionalParam.isNotEmpty)
//   PayUPaymentParamKey.additionalParam: additionalParam,
```

If you ever need real UDFs, build them locally — never accept arbitrary keys from the backend.

### 5.2 Send `si_details` correctly + add `isPreAuthTxn`

```dart
PayUPaymentParamKey.payUSIParams: {
  PayUSIParamsKeys.isPreAuthTxn:    true,                  // first txn = mandate registration
  PayUSIParamsKeys.billingAmount:   si['billingAmount'],
  PayUSIParamsKeys.billingCurrency: si['billingCurrency'] ?? 'INR',
  PayUSIParamsKeys.billingCycle:    'yearly',              // lowercase per SDK
  PayUSIParamsKeys.billingInterval: '${si['billingInterval'] ?? 1}',
  PayUSIParamsKeys.paymentStartDate: si['paymentStartDate'],
  PayUSIParamsKeys.paymentEndDate:   si['paymentEndDate'],
  PayUSIParamsKeys.billingRule:     si['billingRule'] ?? 'MAX',
  PayUSIParamsKeys.remarks:         si['remarks'] ?? 'CouponApp Subscription',
},
```

> `isPreAuthTxn: true` is what flips the SDK into the mandate-registration UI. Without it, the SDK opens a normal one-time UPI flow.

### 5.3 `userCredential`

```dart
PayUPaymentParamKey.userCredential: params['userCredential'] ?? '',  // backend now sends ''
```

### 5.4 Don't pass an `android_surl`/`ios_surl` of `payu.in/txnstatus`

Those URLs are placeholders and only used by the SDK's WebView fallback. They're harmless for the success/failure callback flow you actually use, but make them point to your real HTTPS endpoints (or a stable PayU-provided dummy) — at minimum:

```dart
PayUPaymentParamKey.android_surl: 'https://api.couponapp.in/api/v1/payments/redirect/success',
PayUPaymentParamKey.android_furl: 'https://api.couponapp.in/api/v1/payments/redirect/failure',
```

(These need not actually exist as endpoints; PayU will only hit them in WebView fallback paths. But use a domain you control to avoid being blocked.)

### 5.5 `generateHash` callback already correct

Your current [`payu_service.dart:91-111`](CouponCustomer/lib/core/services/payu_service.dart#L91-L111) implementation is correct — it round-trips `hashName` and computes `hashString` server-side. Keep it.

The server's `computeHashFromString(hashString, salt)` (`SHA512(hashString + salt)`) is also correct. The SDK provides everything up to (but not including) the salt.

### 5.6 Result polling

Your 3 s `Future.delayed` then `ref.invalidate(profileProvider)` is fine for the happy path, but flaky on slow webhooks. Better:

```dart
payuService.onSuccess = (mihpayid) async {
  // Poll /users/me up to 5 times with 2s gap until subscription becomes ACTIVE
  for (var i = 0; i < 5; i++) {
    await Future.delayed(const Duration(seconds: 2));
    ref.invalidate(profileProvider);
    final profile = await ref.read(profileProvider.future);
    if (profile.subscription?.status == 'ACTIVE') break;
  }
  state = const AsyncData(null);
};
```

### 5.7 Android manifest

Make sure these are present in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="upi"/>
  </intent>
</queries>
```

Without `<queries>`, on Android 11+ the SDK can't enumerate installed UPI apps and the "Pay via GPay/PhonePe" buttons go grey.

---

## 6. Hash Formulas — Single Source of Truth

| Hash | When | Formula |
|---|---|---|
| **Payment (regular)** | Non-SI flow | `SHA512(key\|txnid\|amount\|productinfo\|firstname\|email\|udf1\|udf2\|udf3\|udf4\|udf5\|\|\|\|\|\|SALT)` |
| **Payment (SI)** | UPI Autopay | `SHA512(key\|txnid\|amount\|productinfo\|firstname\|email\|udf1\|udf2\|udf3\|udf4\|udf5\|\|\|\|\|\|si_details\|SALT)` |
| **`payment_related_details_for_mobile_sdk`** | SDK init | `SHA512(key\|payment_related_details_for_mobile_sdk\|userCredential\|SALT)` |
| **`vas_for_mobile_sdk`** | SDK init | `SHA512(key\|vas_for_mobile_sdk\|default\|SALT)` |
| **Webhook reverse (SI)** | Inbound webhook | `SHA512(SALT\|si_details\|status\|\|\|\|\|\|udf5\|udf4\|udf3\|udf2\|udf1\|email\|firstname\|productinfo\|amount\|txnid\|key)` |
| **Webhook reverse (non-SI)** | Inbound webhook | `SHA512(SALT\|status\|\|\|\|\|\|udf5\|udf4\|udf3\|udf2\|udf1\|email\|firstname\|productinfo\|amount\|txnid\|key)` |
| **`si_transaction` (recurring)** | Server-side debit | `SHA512(key\|si_transaction\|var1\|SALT)` where `var1` is the JSON request body |

> **Rule of thumb when using `generateHash` callback**: never pre-compute the payment hash on the server. The SDK gives you the exact hashString; just compute `SHA512(hashString + SALT)` and return it. Pre-computing only works for the V1 hash if you also generate the **identical** `si_details` JSON byte-for-byte the SDK does — which is brittle.

---

## 7. Webhook Contract

### Endpoint

```
POST /api/v1/payments/webhook
Content-Type: application/x-www-form-urlencoded
```

### Notable fields PayU sends

| Field | Notes |
|---|---|
| `mihpayid` | Unique PayU transaction ID — **store this**. |
| `txnid` | Your `sub_<userId>_<ts>` from initiate. |
| `status` | `success`, `failure`, `pending`, `usercancelled`. |
| `unmappedstatus` | Granular status — log for debug. |
| `hash` | Reverse hash — verify with the SI formula above. |
| `si_details` | JSON string of the SI params. Include in reverse hash. |
| `auth_payuid` / `authPayUID` | **Mandate reference — store this for `si_transaction` recurring debits.** |
| `error_Message`, `error_code` | Populated on `status != success`. |
| `productinfo`, `amount`, `email`, `firstname`, `phone` | Echo of request fields. |
| `additionalCharges` | Sometimes present; if so, it gets prepended to the reverse-hash string. |

### Response

Always reply `200 OK` immediately, then process async. PayU retries non-2xx for up to 24 h.

```ts
res.status(200).json({ status: 'ok' });
paymentService.handleWebhook(req.body).catch(console.error);
```

### Idempotency

Key on `mihpayid` (Redis 48 h). PayU may send the same webhook 3–5 times.

---

## 8. Recurring Debit (`si_transaction`)

After a mandate is registered (`authPayUID` stored), recurring debits don't need user interaction. Your backend POSTs to PayU's postservice URL with a signed `si_transaction` command.

### Request

```
POST {baseUrl}/merchant/postservice.php?form=2
Content-Type: application/x-www-form-urlencoded

key={merchantKey}
command=si_transaction
var1={JSON-string of debit details}
hash={SHA512(key|si_transaction|var1|SALT)}
```

### `var1` JSON shape

```json
{
  "txnid": "renew_<userId8>_<ts>",
  "amount": "999.00",
  "productinfo": "CouponApp Annual Renewal",
  "firstname": "Tushar",
  "email": "tushar@example.com",
  "phone": "9876543210",
  "authpayuid": "<authPayUID stored from initial mandate>"
}
```

### BullMQ job

Create a daily repeatable job in `src/jobs/recurringDebits.ts`:

```ts
// 1. Find all subscriptions whose endDate is exactly +24h from now
// 2. For each, send pre-debit notification (RBI), record sentAt
// 3. Find all subscriptions whose endDate is now (or yesterday) AND pre-debit
//    notification was sent ≥24h ago
// 4. Call si_transaction; on success, extend endDate by validityDays
// 5. On failure, mark subscription EXPIRED, notify user to re-subscribe
```

### Bank failure modes for recurring debits

| Failure | Cause | Action |
|---|---|---|
| `E000` insufficient balance | User wallet empty | Retry next day; after 3 fails, mark EXPIRED |
| `E001` mandate revoked | User cancelled in their bank app | Mark `Subscription.status = EXPIRED`, push notification |
| `E1101` bad params | Bug — alert dev | Log, manual fix |

---

## 9. RBI Pre-Debit Notification

RBI's Auto Debit Framework (Aug 2021) requires:
- Customer notified ≥24 h before each recurring debit.
- Notification must include amount + merchant name + debit date.
- Customer can cancel/skip from the notification (handled by your bank/UPI app — not your responsibility).

### Implementation

1. BullMQ job runs daily at 09:00 IST.
2. For each subscription expiring in exactly 1 day (24-26 h window), send:
   - **Push** (OneSignal) — "₹999 will be debited tomorrow for CouponApp annual renewal"
   - **SMS** (MSG91) — same message; SMS is the legally-safer channel.
3. Record `preDebitNotifiedAt` on the subscription.
4. The recurring debit job won't fire `si_transaction` unless `preDebitNotifiedAt` is set and ≥24 h old.

```ts
// jobs/preDebitNotification.ts
const subs = await prisma.subscription.findMany({
  where: {
    status: 'ACTIVE',
    endDate: { gte: tomorrow, lt: dayAfterTomorrow },
    preDebitNotifiedAt: null,
  },
  include: { user: true },
});

for (const s of subs) {
  await oneSignal.sendToUser(s.userId, '📅 Upcoming Auto-Debit',
    `₹999 will be debited on ${fmt(s.endDate)} for CouponApp annual renewal.`,
    'pre_debit_alert');
  await msg91.sendSms(s.user.phone, predebitTemplateId, { amount: '999', date: fmt(s.endDate) });
  await prisma.subscription.update({
    where: { id: s.id },
    data: { preDebitNotifiedAt: new Date() },
  });
}
```

---

## 10. Database Schema

### Add to `Subscription`

```prisma
model Subscription {
  id                  String              @id @default(uuid())
  userId              String              @unique
  startDate           DateTime
  endDate             DateTime
  status              SubscriptionStatus  @default(ACTIVE)

  // PayU Autopay
  payuPaymentId       String?             // mihpayid (latest debit)
  authPayUID          String?             // mandate reference — REQUIRED for si_transaction
  mandateStartDate    DateTime?
  mandateEndDate      DateTime?
  preDebitNotifiedAt  DateTime?           // RBI compliance
  lastRenewalAt       DateTime?
  renewalFailureCount Int                 @default(0)

  createdAt           DateTime            @default(now())
  updatedAt           DateTime            @updatedAt

  user                User                @relation(fields: [userId], references: [id])
  couponBook          CouponBook?
  attempts            PaymentAttempt[]

  @@map("subscriptions")
}
```

### New `PaymentAttempt`

```prisma
enum PaymentAttemptStatus { PENDING SUCCESS FAILED CANCELLED }

model PaymentAttempt {
  id             String                @id @default(uuid())
  userId         String
  subscriptionId String?
  txnid          String                @unique
  amount         Decimal               @db.Decimal(10, 2)
  kind           String                // "MANDATE" | "RENEWAL"
  status         PaymentAttemptStatus  @default(PENDING)
  payuPaymentId  String?
  authPayUID     String?
  errorCode      String?
  errorMessage   String?
  rawWebhook     Json?
  createdAt      DateTime              @default(now())
  updatedAt      DateTime              @updatedAt

  user           User                  @relation(fields: [userId], references: [id])
  subscription   Subscription?         @relation(fields: [subscriptionId], references: [id])

  @@index([userId])
}
```

Run:
```bash
npx prisma migrate dev --name payu_autopay_schema
```

---

## 11. Test Plan

### Sandbox credentials

| Field | Value |
|---|---|
| Merchant Key | `gtKFFx` |
| Merchant Salt | `eCwWELxi` |
| Test endpoint | `https://test.payu.in` |
| SDK env flag | `'1'` (test) |
| UPI VPA | any `*@payu` (e.g., `success@payu`, `failure@payu`) |

### Manual test matrix

| # | Scenario | Expected |
|---|---|---|
| 1 | Happy path — `success@payu` | Mandate registered, ₹999 debited, subscription ACTIVE, `mihpayid`+`authPayUID` saved |
| 2 | Insufficient funds — `failure@payu` | Webhook `status=failure`, `PaymentAttempt.status=FAILED`, no subscription created |
| 3 | User cancels in UPI app | `onPaymentCancel` fires, no webhook, controller shows "Cancelled" toast |
| 4 | Webhook arrives twice (PayU retry) | Second webhook is no-op (idempotency on `mihpayid`) |
| 5 | Webhook hash mismatch (tamper test) | Reject + log; subscription stays inactive |
| 6 | App killed mid-payment | Webhook fulfils on backend; user reopens app, profile shows ACTIVE |
| 7 | Slow `/generate-hash` (Render cold start) | SDK waits up to 10 s; if longer, payment fails gracefully |
| 8 | Recurring debit on renewal day | `si_transaction` fires, subscription extended, no user interaction |
| 9 | Recurring debit fails (mandate revoked) | Subscription EXPIRED, push notification asks user to re-subscribe |
| 10 | Pre-debit notification | Push + SMS arrive ≥24 h before debit |

### Smoke-test command

```bash
# Verify hash function with PayU's online tool
# https://payu.in/test-hash-generator
curl -X POST https://test.payu.in/_payment \
  -d "key=gtKFFx&txnid=test123&amount=10.00&productinfo=Test&firstname=Test&email=test@test.com&phone=9999999999&surl=https://payu.in/txnstatus&furl=https://payu.in/txnstatus&hash=<computed>&si=1&si_details={...}"
```

---

## 12. Common Failure Modes

| Symptom | Likely cause | Fix |
|---|---|---|
| **Checkout screen stuck on "Processing…"** | `payment_related_details_for_mobile_sdk` hash wrong or not returned in `generateHash` callback | Confirm `generateHash` callback handles every `hashName` the SDK requests; log `hashName` to verify |
| **PayU returns "Sorry, error occurred. Please try a different payment option"** | Payment hash mismatch — usually caused by pre-computed hash + SDK building different `si_details` JSON | Stop pre-computing; rely solely on `generateHash` callback |
| **Webhook arrives but subscription never activates** | Reverse hash verify fails (BLOCKER B1) | Use the SI-aware reverse hash (§4.1) |
| **"Cancelled by user" instantly after MPIN** | `isPreAuthTxn` not set, so SDK is in one-time mode and bank rejects the SI request | Set `PayUSIParamsKeys.isPreAuthTxn: true` |
| **Mandate registered but no recurring debit happens** | No BullMQ job to call `si_transaction` | Implement §8 |
| **`authPayUID` is empty string in webhook** | Key name mismatch (`auth_payuid` vs `authPayUID`) | Read both: `body.auth_payuid \|\| body.authPayUID` |
| **`generateHash` callback fires but hash never returns** | Backend slow + SDK timeout | Set `merchantResponseTimeout: 10`; warm/upgrade the API host |
| **UPI app buttons greyed out on Android 11+** | Missing `<queries>` block in manifest | Add `<intent><data android:scheme="upi"/></intent>` |
| **Phone validation fails at PayU** | `+91` prefix sent | Strip in backend: `phone.replace(/^\+91/, '')` |
| **Test transaction succeeds but production fails** | Forgot to switch `PAYU_ENV=production` and SDK env flag | Verify `params['env'] === 'production'` → SDK gets `'0'` |

---

## File Change Summary

### CouponAPI

| Action | File | Reason |
|---|---|---|
| **EDIT** | `src/shared/utils/payuHash.ts` | Fix `verifyPayUWebhookHash` to include `si_details` (B1) |
| **EDIT** | `src/modules/payments/payments.service.ts` | Drop dead-code hash + `additionalParam`; bump TTL; persist PaymentAttempt; 30-yr mandate |
| **EDIT** | `src/modules/payments/payments.swagger.ts` | Replace Razorpay docs with PayU |
| **EDIT** | `src/modules/payments/payments.validator.ts` | Replace `createOrderResponseSchema` with `initiatePaymentResponseSchema` |
| **EDIT** | `prisma/schema.prisma` | Add `PaymentAttempt`, extend `Subscription` |
| **NEW** | `src/jobs/preDebitNotification.ts` | Daily RBI compliance job |
| **NEW** | `src/jobs/recurringDebits.ts` | Daily `si_transaction` job |

### CouponCustomer

| Action | File | Reason |
|---|---|---|
| **EDIT** | `lib/core/services/payu_service.dart` | Drop `additionalParam` forwarding; add `isPreAuthTxn: true`; correct `userCredential` |
| **EDIT** | `lib/features/payment/presentation/payment_controller.dart` | Replace fixed 3 s delay with profile polling loop |
| **EDIT** | `android/app/src/main/AndroidManifest.xml` | Add `<queries>` for UPI scheme (Android 11+) |

---

## Quick reference — Drop-in `payments.service.ts` (post-fix)

```ts
import { prisma } from '../../config/db';
import { redis }  from '../../config/redis';
import { env }    from '../../config/env';
import { ConflictError } from '../../shared/utils/AppError';
import {
  computeHashFromString,
  verifyPayUWebhookHash,
} from '../../shared/utils/payuHash';
import { oneSignal } from '../notifications/onesignal.service';

export class PaymentService {
  async initiatePayment(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ConflictError('User not found');

    const existing = await prisma.subscription.findUnique({ where: { userId } });
    if (existing?.status === 'ACTIVE') {
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
      data: {
        userId, txnid, kind: 'MANDATE',
        amount: amount as any, status: 'PENDING',
      },
    });
    await redis.set(`payu_txn:${txnid}`, userId, 'EX', 48 * 3600);

    return {
      key:         env.PAYU_KEY,
      txnid,
      amount,
      productinfo: 'CouponApp Premium',
      firstname,
      email,
      phone,
      userCredential: '',
      env:         env.PAYU_ENV,
      si_details:  siParams,
    };
  }

  generateHash(hashString: string): string {
    return computeHashFromString(hashString, env.PAYU_SALT);
  }

  async handleWebhook(body: Record<string, string>): Promise<void> {
    if (!verifyPayUWebhookHash(body, env.PAYU_SALT)) {
      console.error('[PayU Webhook] Hash mismatch', { txnid: body.txnid });
      return;
    }

    const { txnid, mihpayid, status, error_Message } = body;
    const authPayUID = body.auth_payuid || body.authPayUID || '';

    const idKey = `payu_processed:${mihpayid}`;
    if (await redis.get(idKey)) return;

    const userId =
      (await redis.get(`payu_txn:${txnid}`)) ??
      (await prisma.paymentAttempt.findUnique({ where: { txnid } }))?.userId;
    if (!userId) {
      console.error('[PayU Webhook] Unknown txnid', { txnid });
      return;
    }

    if (status === 'success') {
      await this.fulfillSubscription(userId, mihpayid, authPayUID);
      await prisma.paymentAttempt.update({
        where: { txnid },
        data:  {
          status: 'SUCCESS',
          payuPaymentId: mihpayid,
          authPayUID,
          rawWebhook: body as any,
        },
      });
      oneSignal.sendToUser(userId,
        '🎉 Subscription Activated!',
        'Your coupon book is now active!',
        'subscription_success').catch(()=>{});
    } else {
      await prisma.paymentAttempt.update({
        where: { txnid },
        data:  {
          status: 'FAILED',
          errorMessage: error_Message,
          rawWebhook: body as any,
        },
      });
    }

    await redis.set(idKey, '1', 'EX', 48 * 3600);
  }

  private async fulfillSubscription(/* unchanged from current */) { /* … */ }
}
```

---

## Reference docs

- [UPI Intent & Collect Autopay (TPV)](https://docs.payu.in/docs/upi-intent-and-collect-autopay-tpv-integration)
- [Flutter CheckoutPro SDK Integration Steps](https://docs.payu.in/docs/flutter-checkoutprosdk-integration-steps)
- [Flutter CheckoutPro SDK Advanced](https://docs.payu.in/docs/flutter-checkoutprosdk-advanced-integration)
- [SI Parameter JSON Details](https://docs.payu.in/reference/si-parameter-json-details)
- [Webhooks for Payments](https://docs.payu.in/reference/webhooks)
- [GitHub: payu-intrepos/PayUCheckoutPro-Flutter](https://github.com/payu-intrepos/PayUCheckoutPro-Flutter)
