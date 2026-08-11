# PayU → Razorpay Migration — Complete Implementation Plan

> **Goal:** remove PayU UPI Intent Autopay entirely and replace it with Razorpay UPI Autopay across
> `CouponAPI` (backend), `CouponCustomer` (Flutter), and `CouponAdmin` (React).
> `CouponSeller` is out of scope — it has no payment-gateway code.
>
> **Audited against:** the current repo (branch `razorpay-pg`) and the Razorpay docs
> (Recurring Payments / UPI Autopay, Subscriptions, Webhooks, `razorpay_flutter` 1.4.5).
>
> **Date:** 2026-08-07

---

## Table of Contents

1. [Current PayU Footprint (what gets deleted)](#1-current-payu-footprint)
2. [Gateway Model Decision — Tokens vs Subscriptions](#2-gateway-model-decision)
3. [Target Architecture & Flow](#3-target-architecture--flow)
4. [Concept Mapping PayU → Razorpay](#4-concept-mapping)
5. [Backend Changes — CouponAPI](#5-backend-changes--couponapi)
6. [Mobile Changes — CouponCustomer](#6-mobile-changes--couponcustomer)
7. [Admin Changes — CouponAdmin](#7-admin-changes--couponadmin)
8. [Database Schema & Migration](#8-database-schema--migration)
9. [Existing PayU Mandates — Cutover Strategy](#9-existing-payu-mandates--cutover-strategy)
10. [Razorpay Dashboard Setup Checklist](#10-razorpay-dashboard-setup-checklist)
11. [Test Plan](#11-test-plan)
12. [Rollout & Rollback](#12-rollout--rollback)
13. [File-Change Summary](#13-file-change-summary)
14. [Open Questions / Verify Before Coding](#14-open-questions--verify-before-coding)

---

## 1. Current PayU Footprint

### CouponAPI (backend)

| File | What it holds |
|---|---|
| `src/config/payu.ts` | key / salt / baseUrl (test vs secure.payu.in) |
| `src/config/env.ts` | `PAYU_KEY`, `PAYU_SALT`, `PAYU_MERCHANT_ID`, `PAYU_ENV` |
| `src/shared/utils/payuHash.ts` | `generatePayUHash`, `computeHashFromString`, `verifyPayUWebhookHash` (SI-aware reverse hash) |
| `src/modules/payments/payments.service.ts` | `initiatePayment`, `generateHash`, `handleWebhook`, `fulfillSubscription`, `cancelAutopay` (`upi_mandate_revoke`), `getPaymentHistory` |
| `src/modules/payments/payments.controller.ts` | 5 handlers |
| `src/modules/payments/payments.routes.ts` | `/initiate`, `/generate-hash`, `/webhook` (urlencoded), `/cancel-autopay`, `/history` |
| `src/modules/payments/payments.validator.ts` | `siDetailsSchema`, `initiatePaymentResponseSchema`, `generateHashRequestSchema` |
| `src/modules/payments/payments.swagger.ts` | OpenAPI for the three PayU routes |
| `src/jobs/recurringDebits.job.ts` | BullMQ daily 09:00 — PayU `si_transaction` postservice call |
| `prisma/schema.prisma` | `Subscription.payuPaymentId`, `.authPayUID`, `.mandateStartDate/EndDate`; `PaymentAttempt.txnid/.payuPaymentId/.authPayUID` |
| `src/database/seed.ts:207` | `payuPaymentId: 'pay_TEST123'` |
| `.env.example` | **already** carries stale `RAZORPAY_*` keys and no `PAYU_*` — needs a correct rewrite |

### CouponCustomer (Flutter)

| File | What it holds |
|---|---|
| `pubspec.yaml:39` | `payu_checkoutpro_flutter: ^1.4.3` |
| `lib/core/services/payu_service.dart` | `PayUService implements PayUCheckoutProProtocol`, SI params, `generateHash` callback |
| `lib/core/di/injection.dart:39,68` | `registerLazySingleton<PayUService>` |
| `lib/core/config/app_config.dart` | `payuMerchantKey` from `--dart-define=PAYU_KEY` |
| `lib/main.dart:14` | doc comment referencing `PAYU_KEY` |
| `lib/features/payment/data/payment_repository.dart` | `initiatePayment()`, `generateHash()` |
| `lib/features/payment/presentation/payment_controller.dart` | orchestrates SDK + profile polling |
| `lib/features/subscription/.../purchase_screen.dart:355` | `'SECURE PAYMENT VIA PAYU'` copy |
| `lib/features/subscription/.../my_subscriptions_screen.dart` | **fully mocked** — no real API wiring for history/cancel-autopay |
| `android/app/src/main/AndroidManifest.xml` | PayU comments, `FOREGROUND_SERVICE` removals, `upi` scheme `<queries>` |
| `android/app/proguard-rules.pro` | `-keep class com.payu.**`, GPay `-dontwarn` block |

### CouponAdmin (React)

| File | What it holds |
|---|---|
| `src/types/api/users.ts:53-54` | `razorpayOrderId` / `razorpayPaymentId` on `UserSubscription` — **stale, unused, and does not match the backend response** (`users.service.ts` only selects `status`, `endDate`) |

No admin screen consumes gateway fields today. Admin work is a type cleanup plus (optional) a new payments view.

---

## 2. Gateway Model Decision

Razorpay offers two ways to do UPI Autopay. This choice drives everything else, so settle it first.

### Option A — Recurring Payments (token / mandate) ✅ **Recommended**

You create a Customer, create an Order carrying `token: { max_amount, expire_at, frequency }`,
run the first payment through Checkout with `recurring: "1"`, and receive a `token_id`.
On each renewal your backend creates a fresh Order and calls `POST /v1/payments/create/recurring`.

**Why it fits CouponApp:**

- **Price is admin-configurable** (`AppSetting.subscription_price`) and may become per-city. A token has a
  `max_amount` ceiling, not a fixed price — you can debit any amount up to the cap without re-registering the mandate.
- **Validity is 45–50 days** (`AppSetting.book_validity_days`), which does not map to a Razorpay plan `period`
  (`daily`/`weekly`/`monthly`/`yearly` × `interval`), but does fit *under* a `monthly` token frequency — see the
  **Confirmed mandate parameters** box below.
- **Structural 1:1 with the code you already have.** `authPayUID` → `token_id`, `si_transaction` → `create/recurring`,
  `upi_mandate_revoke` → token cancel. `recurringDebits.job.ts`, `isAutopayEnabled`, `PaymentAttempt`, and
  `fulfillSubscription` all survive with their shapes intact.

**Cost:** you keep owning the renewal scheduler and retry logic.

> **Confirmed mandate parameters (resolved from §14, was open):**
> - `token.max_amount` = **₹5,000** (`500000` paise). Well above the current ₹999 price, leaves headroom for
>   admin price increases, and is safely under the ₹15,000 UPI Autopay ceiling that would trigger extra
>   authentication.
> - `token.frequency` = **`"monthly"`**, not `"as_presented"`. A `monthly` mandate caps you at *at most one*
>   debit per calendar month — it does not force one. Since renewals fire ~45–50 days apart (i.e. less often
>   than once a month), every renewal debit satisfies that cap. This is cheaper to get approved than
>   `as_presented` and matches what's already enabled on the account.

### Option B — Razorpay Subscriptions

Create a Plan, create a Subscription, hand `subscription_id` to Checkout, and let Razorpay run the
billing calendar, retries, and invoices. You only consume `subscription.charged` / `.halted` / `.cancelled`.

**Why it does not fit today:** amount and period are frozen into the Plan. Changing `subscription_price` means
minting a new Plan and cannot alter in-flight subscriptions; a 45–50 day cycle is not expressible; per-city
pricing would multiply plans.

### Decision

**Go with Option A.** Section 5 onward is written for Option A.
If the product later fixes the price and moves to a clean monthly/yearly cycle, Option B becomes a worthwhile
simplification — the `PaymentAttempt` / webhook plumbing built here is reusable.

---

## 3. Target Architecture & Flow

### 3.1 Mandate registration + first charge

```
User            Flutter                Backend (CouponAPI)            Razorpay
 │  Tap "Buy"      │                          │                          │
 ├────────────────>│  POST /payments/initiate │                          │
 │                 ├─────────────────────────>│                          │
 │                 │                          │ POST /v1/customers       │
 │                 │                          │  (once per user, cached) │
 │                 │                          ├─────────────────────────>│
 │                 │                          │<──── customer_id ────────┤
 │                 │                          │ POST /v1/orders          │
 │                 │                          │  amount, method: upi,    │
 │                 │                          │  customer_id,            │
 │                 │                          │  token:{max_amount,      │
 │                 │                          │    expire_at, frequency} │
 │                 │                          │  notes:{userId, kind}    │
 │                 │                          ├─────────────────────────>│
 │                 │                          │<──── order_id ───────────┤
 │                 │                          │ PaymentAttempt PENDING   │
 │                 │ {keyId, orderId,         │                          │
 │                 │  customerId, amount,     │                          │
 │                 │<─ prefill, name, desc} ──┤                          │
 │                 │                          │                          │
 │                 │ Razorpay().open({key, order_id, customer_id,        │
 │                 │                  recurring:'1', prefill, ...})      │
 │                 ├────────────────────────────────────────────────────>│
 │  UPI app: approve mandate (MPIN)           │                          │
 │<───────────────────────────────────────────────────────────────────── │
 │                 │                          │                          │
 │                 │                          │  POST /payments/webhook  │
 │                 │                          │  payment.captured        │
 │                 │                          │  (+ token.confirmed)     │
 │                 │                          │<─────────────────────────┤
 │                 │                          │ verify X-Razorpay-       │
 │                 │                          │   Signature (raw body)   │
 │                 │                          │ store token_id,          │
 │                 │                          │   customer_id            │
 │                 │                          │ fulfillSubscription()    │
 │                 │                          │                          │
 │                 │ EVENT_PAYMENT_SUCCESS    │                          │
 │                 │<─────────────────────────────────────────────────── │
 │                 │ POST /payments/verify (order|payment|signature)     │
 │                 ├─────────────────────────>│ HMAC check, optimistic   │
 │                 │                          │ fulfil if webhook late   │
 │                 │ poll profileProvider     │                          │
 │<── ACTIVE ──────┤                          │                          │
```

### 3.2 Renewal (no user interaction)

```
BullMQ daily 09:00  →  find subs where isAutopayEnabled && razorpayTokenId != null
                         && endDate between now+24h and now+72h
                         && renewalFailureCount < 3
                    →  POST /v1/orders            (fresh order, notes.kind = RENEWAL)
                    →  POST /v1/payments/create/recurring
                         { email, contact, amount, currency, order_id,
                           customer_id, token, recurring: true, description }
                    →  PaymentAttempt(kind: RENEWAL, status: PENDING)
                    ...
                    UPI debit settles in 24–36 h
                    →  webhook payment.captured  → extend endDate, new CouponBook, award coins
                    →  webhook payment.failed    → renewalFailureCount++, retry tomorrow;
                                                    after 3 → EXPIRED + push to re-subscribe
```

**Critical timing rule:** Razorpay states UPI subsequent payments take **24–36 hours** to reflect, and that you must
**not** create the debit on the last day of the cycle. Fire the charge **48–72 h before `endDate`**, and extend the
subscription **only** on `payment.captured` — never optimistically at charge-creation time.

**Pre-debit notification:** for UPI Autopay, the mandatory RBI 24-hour pre-debit notification is issued by the
PSP/NPCI as part of the debit flow — you do not send it yourself (unlike the PayU design, which needed a custom
job). Keep an app-level courtesy push (existing `preDebitNotifiedAt` field) but it is no longer a compliance gate.

---

## 4. Concept Mapping

| PayU | Razorpay | Notes |
|---|---|---|
| `key` + `salt` | `RAZORPAY_KEY_ID` + `RAZORPAY_KEY_SECRET` | key_id is public and safe to ship to the client |
| SHA-512 hashes everywhere | HMAC-SHA256 signatures | **The whole `generateHash` round-trip disappears** |
| `/payments/generate-hash` route | *(deleted)* | Razorpay SDK needs no server hash callback |
| `txnid` (`sub<uid><ts>`) | `order_id` (`order_xxx`) | server-generated by Razorpay; keep our `receipt` for traceability |
| `mihpayid` | `razorpay_payment_id` (`pay_xxx`) | |
| `authPayUID` | `token_id` (`token_xxx`) | the mandate handle |
| — | `customer_id` (`cust_xxx`) | new concept; store on `User`, create once |
| `si_details` JSON | Order `token: { max_amount, expire_at, frequency }` | |
| `isPreAuthTxn: true` | Checkout `recurring: "1"` on a token-bearing order | |
| `si_transaction` postservice | `POST /v1/payments/create/recurring` | |
| `upi_mandate_revoke` | token cancel/delete API (see §14) | |
| reverse hash `SHA512(salt\|si_details\|status\|…)` | `HMAC_SHA256(rawBody, RAZORPAY_WEBHOOK_SECRET)` vs `X-Razorpay-Signature` | must use the **raw** body |
| webhook = form-urlencoded | webhook = **JSON** | route body parser changes |
| amount `"999.00"` (rupee string) | `99900` (paise **integer**) | conversion bugs live here — centralise it |
| `PAYU_ENV=test\|production` | `rzp_test_*` vs `rzp_live_*` key prefix | no separate env flag needed |

---

## 5. Backend Changes — CouponAPI

### 5.1 Dependencies

```bash
cd CouponAPI
npm i razorpay
npm rm ...  # no payu npm package exists to remove — PayU was hand-rolled
```

`razorpay` ships its own types; no `@types/*` needed.

### 5.2 `src/config/env.ts` — replace the PayU block

```ts
// DELETE
// PAYU_KEY, PAYU_SALT, PAYU_MERCHANT_ID, PAYU_ENV

// ADD
RAZORPAY_KEY_ID:         str({ default: '' }),
RAZORPAY_KEY_SECRET:     str({ default: '' }),
RAZORPAY_WEBHOOK_SECRET: str({ default: '' }),
// UPI Autopay mandate ceiling in paise. ₹5,000 confirmed for this account
// (well under the ₹15,000 cap that would trigger extra authentication).
RAZORPAY_MANDATE_MAX_AMOUNT: num({ default: 500_000 }),
// Mandate validity in years (token.expire_at)
RAZORPAY_MANDATE_YEARS:      num({ default: 10 }),
```

### 5.3 `src/config/razorpay.ts` — **new**, replaces `src/config/payu.ts` (delete that file)

```ts
import Razorpay from 'razorpay';
import { env } from './env';

export const razorpay = new Razorpay({
  key_id:     env.RAZORPAY_KEY_ID,
  key_secret: env.RAZORPAY_KEY_SECRET,
});

export const isLiveMode = env.RAZORPAY_KEY_ID.startsWith('rzp_live_');

/** ₹ → paise. Razorpay rejects non-integers. */
export const toPaise  = (rupees: number | string) => Math.round(Number(rupees) * 100);
export const toRupees = (paise: number) => (paise / 100).toFixed(2);
```

### 5.4 `src/shared/utils/razorpaySignature.ts` — **new**, replaces `src/shared/utils/payuHash.ts` (delete that file)

```ts
import crypto from 'crypto';

/** Webhook: HMAC_SHA256(rawBody, webhookSecret) === X-Razorpay-Signature */
export function verifyWebhookSignature(
  rawBody: Buffer | string,
  signature: string,
  secret: string,
): boolean {
  if (!signature) return false;
  const expected = crypto.createHmac('sha256', secret)
    .update(rawBody).digest('hex');
  const a = Buffer.from(expected, 'utf8');
  const b = Buffer.from(signature, 'utf8');
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

/** Checkout callback: HMAC_SHA256(`${orderId}|${paymentId}`, keySecret) === signature */
export function verifyPaymentSignature(
  orderId: string, paymentId: string, signature: string, keySecret: string,
): boolean {
  if (!signature) return false;
  const expected = crypto.createHmac('sha256', keySecret)
    .update(`${orderId}|${paymentId}`).digest('hex');
  const a = Buffer.from(expected, 'utf8');
  const b = Buffer.from(signature, 'utf8');
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}
```

> Use `crypto.timingSafeEqual`, not `===`. The PayU code compared hashes with `===`; don't carry that over.

### 5.5 `src/modules/payments/payments.service.ts` — rewrite

Public surface:

| Method | Purpose |
|---|---|
| `getOrCreateCustomer(user)` | `POST /v1/customers` once; cache `razorpayCustomerId` on `User` |
| `initiatePayment(userId)` | create mandate order, return Checkout options |
| `verifyPayment(userId, {orderId, paymentId, signature})` | client-side confirm; optimistic fulfil if webhook is late |
| `handleWebhook(event, rawBody, signature)` | signature check → idempotency → route by `event` |
| `cancelAutopay(userId)` | cancel the Razorpay token, flip `isAutopayEnabled=false` |
| `getPaymentHistory(userId)` | unchanged shape, new column names |
| `fulfillSubscription(...)` | **unchanged business logic** — only the gateway id params change |

#### `initiatePayment`

```ts
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
  const rupees      = priceSetting ? parseFloat(priceSetting.value) : 999;
  const amountPaise = toPaise(rupees);

  const customerId = await this.getOrCreateCustomer(user);

  const expireAt = Math.floor(
    new Date(new Date().setFullYear(
      new Date().getFullYear() + env.RAZORPAY_MANDATE_YEARS)).getTime() / 1000,
  );

  const order = await razorpay.orders.create({
    amount:      amountPaise,
    currency:    'INR',
    customer_id: customerId,
    method:      'upi',
    token: {
      max_amount: env.RAZORPAY_MANDATE_MAX_AMOUNT,   // ₹5,000 cap
      expire_at:  expireAt,
      // 'monthly' caps us at ≤1 debit per calendar month. Renewals fire
      // ~45–50 days apart, i.e. less often than monthly, so this is never
      // violated — and 'monthly' is what's approved on the account.
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

  return {
    keyId:       env.RAZORPAY_KEY_ID,
    orderId:     order.id,
    customerId,
    amount:      amountPaise,          // paise — hand straight to the SDK
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
```

> `notes: { userId }` is the reliable order→user link. Razorpay echoes `notes` in every webhook payload,
> which removes the fragile Redis `payu_txn:<txnid>` TTL lookup entirely. Keep the `PaymentAttempt` row
> as the durable fallback.

#### `handleWebhook`

Events to handle:

| Event | Action |
|---|---|
| `payment.captured` | `notes.kind === 'MANDATE'` → `fulfillSubscription` + store `token_id`. `'RENEWAL'` → extend `endDate`, new `CouponBook`, award coins, reset `renewalFailureCount` |
| `payment.failed` | mark `PaymentAttempt` FAILED; for RENEWAL bump `renewalFailureCount`, EXPIRE after 3 |
| `payment.authorized` | log only (auto-capture is on) |
| `token.confirmed` | mandate live — persist `token_id`, `max_amount`, `expired_at` |
| `token.rejected` | user declined in the UPI app → `isAutopayEnabled = false` |
| `token.cancelled` / `token.paused` | user revoked from their bank/UPI app → `isAutopayEnabled = false`, push "re-enable autopay" |

> **Resolved during dashboard setup: the `token.*` events do not exist in the webhook event catalog on this**
> **account** — only `payment`, `order`, `invoice`, `subscription` (Subscriptions product, unused here),
> `settlement`, `fund_account`, `refund`, `account`, `payment_link`, `engage` categories are offered. So:
> - **Select only** `payment.authorized`, `payment.captured`, `payment.failed` on the webhook.
> - `onTokenConfirmed` is a no-op in practice — harmless, and not load-bearing: `mandateMaxAmount` /
>   `mandateExpiresAt` are set deterministically from env config inside `fulfillSubscription`, not from this
>   event, specifically to avoid depending on it landing.
> - `onTokenRevoked` **will not fire**. A user who cancels the mandate directly in their bank/UPI app (rather
>   than through the app's "Cancel Autopay" button) is detected **reactively**, not immediately: the next
>   renewal attempt fails against the dead mandate, `payment.failed` fires, `renewalFailureCount` increments,
>   and after 3 failures the subscription goes `EXPIRED` with `isAutopayEnabled = false`. That path already
>   exists and needs no extra code — it's just not instant. Accepted as an MVP limitation.
> - The `token.*` switch cases stay in the handler code (harmless if never invoked, and would just start
>   working if Razorpay ever exposes the category on this account) — this is a webhook-catalog constraint,
>   not a code bug.

```ts
async handleWebhook(rawBody: Buffer, signature: string, eventId: string) {
  if (!verifyWebhookSignature(rawBody, signature, env.RAZORPAY_WEBHOOK_SECRET)) {
    log.error('webhook: signature verification failed — rejected');
    return;
  }

  // Idempotency on Razorpay's own event id (header: x-razorpay-event-id).
  // Razorpay retries for up to 24 h, so hold the key at least that long.
  const idKey = `rzp_event:${eventId}`;
  if (await redis.set(idKey, '1', 'EX', 48 * 3600, 'NX') !== 'OK') {
    log.warn('webhook: duplicate delivery ignored', { eventId });
    return;
  }

  const body = JSON.parse(rawBody.toString('utf8'));
  switch (body.event) {
    case 'payment.captured': return this.onPaymentCaptured(body.payload.payment.entity);
    case 'payment.failed':   return this.onPaymentFailed(body.payload.payment.entity);
    case 'token.confirmed':  return this.onTokenConfirmed(body.payload.token.entity);
    case 'token.cancelled':
    case 'token.paused':
    case 'token.rejected':   return this.onTokenRevoked(body.payload.token.entity);
    default:
      log.info('webhook: unhandled event', { event: body.event });
  }
}
```

> Use `SET … NX` for the idempotency key, not `GET` then `SET`. The current PayU code has a
> read-then-write race that lets two concurrent retries both fulfil.

#### `cancelAutopay`

Replaces the `upi_mandate_revoke` postservice block. Cancel the token at Razorpay, then flip the flag locally
regardless of the API result (so the renewal job never fires again) — same defensive posture as today.
See §14 for the exact endpoint to confirm.

#### `getPaymentHistory`

Same response shape; swap `txnid` → `razorpayOrderId` (or expose `receipt`), keep `amount`, `createdAt`, `kind`.
Flutter's `PaymentAttemptModel` changes with it (§6.7).

### 5.6 `src/modules/payments/payments.routes.ts` — rewrite

```ts
router.post('/initiate',       authenticate, paymentController.initiatePayment);
router.post('/verify',         authenticate, paymentController.verifyPayment);   // NEW
router.post('/webhook',        express.raw({ type: 'application/json' }), paymentController.webhook);
router.post('/cancel-autopay', authenticate, paymentController.cancelAutopay);
router.get ('/history',        authenticate, paymentController.getPaymentHistory);
// DELETE: /generate-hash
```

> **Body-parser gotcha.** `app.ts:21-29` already stashes `req.rawBody` for URLs containing `/webhook` via the
> `express.json` verify hook. Either (a) keep that and read `req.rawBody`, or (b) mount `express.raw` on the
> route as above — but **do not** do both, and make sure `express.urlencoded` (`app.ts:30`) does not consume the
> body first. Option (b) with an explicit route-level parser is the clearer of the two; if you take it, drop the
> now-dead `verify` hook in `app.ts`.

### 5.7 `src/modules/payments/payments.controller.ts`

- Delete `generateHash`.
- Add `verifyPayment` (body: `razorpay_order_id`, `razorpay_payment_id`, `razorpay_signature`).
- `webhook`: read `req.headers['x-razorpay-signature']` and `req.headers['x-razorpay-event-id']`,
  respond `200` immediately, process async (keep the existing pattern — Razorpay retries on non-2xx).

### 5.8 `src/modules/payments/payments.validator.ts` — rewrite

```ts
export const initiatePaymentResponseSchema = z.object({
  keyId: z.string(), orderId: z.string(), customerId: z.string(),
  amount: z.number().int(), currency: z.literal('INR'),
  name: z.string(), description: z.string(), recurring: z.literal('1'),
  prefill: z.object({ name: z.string(), email: z.string(), contact: z.string() }),
});

export const verifyPaymentRequestSchema = z.object({
  razorpay_order_id:   z.string().min(1),
  razorpay_payment_id: z.string().min(1),
  razorpay_signature:  z.string().min(1),
});
```

Delete `siDetailsSchema`, `generateHashRequestSchema`, `generateHashResponseSchema`.

### 5.9 `src/modules/payments/payments.swagger.ts` — rewrite

Document `/initiate`, `/verify`, `/webhook` (JSON body, `X-Razorpay-Signature` header), `/cancel-autopay`,
`/history`. Delete the `/generate-hash` path.

### 5.10 `src/jobs/recurringDebits.job.ts` — rewrite

Keep the BullMQ queue name, the 09:00 cron, and the worker skeleton. Replace the PayU postservice body with:

```ts
const expiring = await prisma.subscription.findMany({
  where: {
    status:              'ACTIVE',
    isAutopayEnabled:    true,
    razorpayTokenId:     { not: null },
    renewalFailureCount: { lt: 3 },
    // Fire 48–72 h ahead: UPI subsequent debits take 24–36 h to settle.
    endDate: { gte: addHours(now, 48), lt: addHours(now, 72) },
  },
  include: { user: true },
});

for (const sub of expiring) {
  // guard: skip if a PENDING RENEWAL attempt already exists for this sub
  const order = await razorpay.orders.create({
    amount: amountPaise, currency: 'INR', payment_capture: true,
    receipt: `rnw_${sub.userId.slice(0, 8)}_${Date.now()}`.slice(0, 40),
    notes: { userId: sub.userId, kind: 'RENEWAL', subscriptionId: sub.id },
  });

  await prisma.paymentAttempt.create({ data: {
    userId: sub.userId, subscriptionId: sub.id,
    razorpayOrderId: order.id, amount: rupees as any,
    kind: 'RENEWAL', status: 'PENDING',
  }});

  await razorpay.payments.createRecurringPayment({
    email:       sub.user.email ?? '',
    contact:     (sub.user.phone ?? '').replace(/^\+91/, ''),
    amount:      amountPaise,
    currency:    'INR',
    order_id:    order.id,
    customer_id: sub.user.razorpayCustomerId!,
    token:       sub.razorpayTokenId!,
    recurring:   true,
    description: 'CouponApp Coupon Book Renewal',
  });
  // Final outcome arrives 24–36 h later via payment.captured / payment.failed.
}
```

Hard rules to encode:

- **Read the price from `AppSetting.subscription_price`** — the current job hardcodes `"999.00"`. That's an existing bug; fix it in the rewrite.
- **One in-flight renewal per subscription.** Razorpay: *"do not create another subsequent payment until you get the status of the previous one."* The `PENDING RENEWAL` guard enforces this.
- **Never debit on the last day of the cycle.** The 48–72 h window handles it.
- **Do not extend `endDate` here.** Only `payment.captured` does.

`src/jobs/preDebitNotification.ts` from the PayU plan was never built — **do not build it**. For UPI Autopay the
PSP sends the compliance notification. A courtesy in-app push is optional.

### 5.11 Other backend touches

| File | Change |
|---|---|
| `src/database/seed.ts:207` | `payuPaymentId: 'pay_TEST123'` → `razorpayPaymentId: 'pay_TEST123'` |
| `src/server.ts` | `recurringDebits.job` is **not currently scheduled** (only expiry/motivation/subscription-expiry are). Add `await scheduleRecurringDebits();` — without it autopay never fires. |
| `.env.example` | rewrite the payments block (it currently lists stale `RAZORPAY_*` keys from the pre-PayU era; make them the real ones and add the two new tunables) |
| `CLAUDE.md` / `ProjectBrief.md` | already say Razorpay — no edit needed |
| `razorpay_implementation_plan.md` (132 lines, one-time-payment design) | supersede or delete; it predates autopay |
| `PAYU_UPI_AUTOPAY_INTEGRATION.md` (repo root) | delete on cutover |

---

## 6. Mobile Changes — CouponCustomer

### 6.1 `pubspec.yaml`

```yaml
  # Payments
  razorpay_flutter: ^1.4.5   # was: payu_checkoutpro_flutter: ^1.4.3
```

Then `flutter pub get`. Requires Android minSdk ≥ 19 and iOS deployment target ≥ 10.0 — both already satisfied.

### 6.2 `lib/core/services/payu_service.dart` → **delete**; add `lib/core/services/razorpay_service.dart`

```dart
import 'package:injectable/injectable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

@singleton
class RazorpayService {
  Razorpay? _razorpay;

  void Function(PaymentSuccessResponse)? onSuccess;
  void Function(String message)? onFailure;

  void initialize() {
    _razorpay?.clear();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) => onSuccess?.call(r))
      ..on(Razorpay.EVENT_PAYMENT_ERROR,   (PaymentFailureResponse r) =>
            onFailure?.call(r.message ?? 'Payment failed'))
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse r) {});
  }

  void openCheckout(Map<String, dynamic> p) {
    _razorpay?.open({
      'key':         p['keyId'],
      'order_id':    p['orderId'],
      'customer_id': p['customerId'],
      'recurring':   '1',              // mandate registration
      'amount':      p['amount'],      // paise, integer
      'currency':    p['currency'] ?? 'INR',
      'name':        p['name'],
      'description': p['description'],
      'prefill':     p['prefill'],
      'theme':       {'color': '#<brand hex>'},
      'retry':       {'enabled': true, 'max_count': 1},
    });
  }

  /// Must be called from the owner's dispose() — the plugin leaks its
  /// method-channel handlers otherwise.
  void dispose() { _razorpay?.clear(); _razorpay = null; }
}
```

Gone with the old file: `PayUCheckoutProProtocol`, `payUSIParams`, `isPreAuthTxn`, `userCredential`,
`android_surl`/`furl`, `merchantResponseTimeout`, and the whole `generateHash` callback.

> `Razorpay.clear()` is mandatory. `PayUService` never needed it; forgetting it here causes duplicate
> success callbacks on a second purchase attempt in the same app session.

### 6.3 `lib/features/payment/data/payment_repository.dart`

- Keep `initiatePayment()`, retype the returned map to the new fields.
- **Delete `generateHash()`.**
- **Add `verifyPayment(orderId, paymentId, signature)`** → `POST /payments/verify`.
- **Add `cancelAutopay()`** → `POST /payments/cancel-autopay` (endpoint exists server-side but the app never called it).
- **Add `getPaymentHistory()`** → `GET /payments/history` (same — never wired).

### 6.4 `lib/features/payment/presentation/payment_controller.dart`

```
1. state = AsyncLoading
2. repo.initiatePayment()                  → params
3. razorpayService.initialize()
4. onSuccess = (r) async {
     await repo.verifyPayment(r.orderId!, r.paymentId!, r.signature!);
     // then poll profileProvider (keep the existing 5×2 s loop —
     //  it is correct and still needed while the webhook lands)
   }
   onFailure = (msg) => state = AsyncError(msg, ...)
5. razorpayService.openCheckout(params)
```

The `BuildContext` argument to `startPaymentFlow` was only needed by `PayUService.initialize(context)` —
drop it from the signature and update the call site in `purchase_screen.dart`.

### 6.5 `lib/core/di/injection.dart`

```dart
import '../services/razorpay_service.dart';           // was payu_service.dart  (line 39)
getIt.registerLazySingleton<RazorpayService>(() => RazorpayService());  // (line 68)
```

### 6.6 `lib/core/config/app_config.dart` + `lib/main.dart`

**Delete `payuMerchantKey` entirely** — do not replace it with `razorpayKeyId`. The backend returns `keyId` in
the `/initiate` response, so the client needs no build-time payment key at all. Remove the field from the
constructor and both `AppConfig.prod()` / `AppConfig.dev()` factories, and drop `PAYU_KEY` from the
`--dart-define` doc comment at `main.dart:14`.

### 6.7 Subscription feature

| File | Change |
|---|---|
| `data/models/payment_history_model.dart` | `PaymentAttemptModel.txnid` → `razorpayOrderId` (or `receipt`); regenerate freezed/`.g.dart` via `dart run build_runner build --delete-conflicting-outputs` |
| `presentation/my_subscriptions_screen.dart` | **currently 100% mocked** (`Future.delayed` + hardcoded rows, fake `cancelAutopay`). Wire `fetchHistory()` → `repo.getPaymentHistory()` and `cancelAutopay()` → `repo.cancelAutopay()`. This is net-new work the PayU build skipped. |
| `presentation/screens/purchase_screen.dart:355` | `'SECURE PAYMENT VIA PAYU'` → `'SECURE PAYMENT VIA RAZORPAY'`; swap the logo placeholders at line 362-364 |

Also add mandate-consent copy to the purchase screen: amount, cap (`max_amount`), cycle, and how to cancel.
UPI Autopay is a standing instruction — the pre-purchase disclosure matters both legally and for store review.

### 6.8 Android — `android/app/src/main/AndroidManifest.xml`

- Line 3 comment: PayU → Razorpay. `INTERNET` stays (Razorpay needs it).
- **Re-evaluate lines 12-14**: `FOREGROUND_SERVICE` / `FOREGROUND_SERVICE_DATA_SYNC` were removed with
  `tools:node="remove"` specifically to strip PayU's manifest merge. Razorpay does not request them —
  delete the removal directives rather than leaving dead `tools:node` overrides.
- Line 72-76: keep the `upi` scheme `<queries>` — Razorpay's UPI intent flow needs it on Android 11+ just as much.

### 6.9 Android — `android/app/proguard-rules.pro`

```proguard
# DELETE
# -keep class com.payu.** { *; }
# -dontwarn com.payu.**

# ADD
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keepclasseswithmembers class * { @com.razorpay.* <methods>; }
-optimizations !method/inlining/*
```

The three `com.google.android.apps.nbu.paisa.inapp.client.api.*` `-dontwarn` lines (13-18) were for PayU's GPay
module — Razorpay ships its own GPay integration, so **keep them**; they suppress the same missing-class warnings.

### 6.10 iOS — `ios/Runner/Info.plist`

`LSApplicationQueriesSchemes` currently holds only `https` and `comgooglemaps`. UPI intent app-switching needs
the UPI app schemes; without them the "Pay with GPay/PhonePe" buttons silently no-op on iOS:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>comgooglemaps</string>
  <string>tez</string>            <!-- Google Pay -->
  <string>phonepe</string>
  <string>paytmmp</string>
  <string>bhim</string>
  <string>credpay</string>
</array>
```

Run `cd ios && pod install` after the pubspec swap.

---

## 7. Admin Changes — CouponAdmin

Small, and mostly hygiene.

1. **`src/types/api/users.ts:47-57`** — `UserSubscription` declares `razorpayOrderId` / `razorpayPaymentId`.
   These are stale leftovers from before the PayU migration, referenced nowhere, and the backend
   (`users.service.ts:94,154`) only returns `{ status, endDate }`. Either delete the fields or align the type
   with the real payload. Do this consciously — do **not** assume they are already correct just because the
   names say "razorpay".

2. **Optional, recommended: a Payments / Subscriptions admin view.** Once `PaymentAttempt` carries
   `razorpayOrderId`, `razorpayPaymentId`, `status`, `kind`, `errorDescription`, support can self-serve failed
   mandates and failed renewals instead of reading server logs. Needs a new admin endpoint
   (`GET /admin/payments?status=&kind=&userId=`) — currently none exists.

3. **`src/pages/admin/Settings.tsx`** — verify `subscription_price` edits are still safe. Under the token model
   they are (the mandate has a `max_amount` ceiling, not a fixed price), but the UI should warn that raising the
   price above `RAZORPAY_MANDATE_MAX_AMOUNT` (₹15,000 default) would break every existing mandate.

---

## 8. Database Schema & Migration

### 8.1 `prisma/schema.prisma`

```prisma
model User {
  // …
  razorpayCustomerId String? @unique   // NEW — cust_xxx, created once, reused forever
}

model Subscription {
  id                  String             @id @default(uuid())
  userId              String             @unique
  startDate           DateTime
  endDate             DateTime
  status              SubscriptionStatus @default(ACTIVE)

  // ── Razorpay (replaces payuPaymentId / authPayUID / mandateStartDate / mandateEndDate)
  razorpayPaymentId   String?            // pay_xxx — latest captured payment
  razorpayTokenId     String?            // token_xxx — the mandate handle
  mandateMaxAmount    Int?               // paise
  mandateExpiresAt    DateTime?

  isAutopayEnabled    Boolean            @default(true)
  preDebitNotifiedAt  DateTime?          // courtesy push only — see §5.10
  lastRenewalAt       DateTime?
  renewalFailureCount Int                @default(0)

  createdAt           DateTime           @default(now())
  updatedAt           DateTime           @updatedAt

  user       User             @relation(fields: [userId], references: [id])
  couponBook CouponBook?
  attempts   PaymentAttempt[]

  @@index([status, isAutopayEnabled, endDate])   // NEW — the renewal job scans on this
  @@map("subscriptions")
}

model PaymentAttempt {
  id                String               @id @default(uuid())
  userId            String
  subscriptionId    String?

  razorpayOrderId   String               @unique   // replaces txnid
  razorpayPaymentId String?              @unique   // replaces payuPaymentId
  razorpayTokenId   String?                        // replaces authPayUID

  amount            Decimal              @db.Decimal(10, 2)
  kind              String                         // "MANDATE" | "RENEWAL"
  status            PaymentAttemptStatus @default(PENDING)
  errorCode         String?
  errorDescription  String?                        // was errorMessage
  rawWebhook        Json?
  createdAt         DateTime             @default(now())
  updatedAt         DateTime             @updatedAt

  user         User          @relation(fields: [userId], references: [id])
  subscription Subscription? @relation(fields: [subscriptionId], references: [id])

  @@index([userId])
  @@index([status, kind])
}

enum PaymentAttemptStatus { PENDING SUCCESS FAILED CANCELLED }   // CANCELLED added
```

### 8.2 Migration

```bash
npx prisma migrate dev --name replace_payu_with_razorpay
```

This migration drops the PayU columns (`payuPaymentId`, `authPayUID`, `mandateStartDate`, `mandateEndDate`,
`txnid`). Per §9, there are zero live PayU mandates in production, so — unlike a typical column-drop — **no
archival/backfill step is needed here**. Take the routine pre-migration backup you'd take for any prod migration,
then apply directly.

The prior `20260422142042_replace_razorpay_with_payu` migration is the mirror image of this one — worth a quick
read before writing this one, just to see the shape of the reverse change.

---

## 9. Existing PayU Mandates — Cutover Strategy

**Resolved (§14 Q7): not applicable.** No client has been onboarded through PayU in production yet — there are
zero live PayU mandates, zero users with `authPayUID` set, and nothing to migrate or revoke. This turns cutover
from a phased migration into a straight swap:

1. Delete the PayU code and the PayU columns in the **same** deploy/migration — no archival step needed, no
   two-mandate transition period, no user notification campaign.
2. `src/database/seed.ts:207` is the only place a PayU identifier exists anywhere in the system — update it as
   part of the same change (§5.11).
3. If that assumption changes before you ship (e.g. a pilot user registers a PayU mandate in the meantime),
   revisit this section before deleting `payuHash.ts` / `config/payu.ts` — PayU mandates cannot be transferred to
   Razorpay, so a live one at cutover time would need the revoke-and-notify treatment this section previously
   described.

---

## 10. Razorpay Dashboard Setup Checklist

Do this before writing code — several items need Razorpay support approval and have lead time.

- [ ] Account KYC complete and activated (live mode).
- [ ] **Request UPI Autopay / Recurring Payments activation.** Not on by default; it is a support-ticket
      enablement on most accounts, with its own approval SLA.
- [ ] Enable **Flash Checkout** if you also plan to use Subscriptions later.
- [ ] Generate **Test** keys (`rzp_test_*`) and **Live** keys (`rzp_live_*`).
- [ ] Create a webhook endpoint: `https://<api-host>/api/v1/payments/webhook`
      - set a strong **webhook secret** → `RAZORPAY_WEBHOOK_SECRET`
      - subscribe: `payment.authorized`, `payment.captured`, `payment.failed`,
        `token.confirmed`, `token.rejected`, `token.cancelled`, `token.paused`
      - create it **separately for Test and Live** — they do not share configuration.
- [ ] Confirm the **UPI Autopay `max_amount` ceiling** applicable to your MCC (§14).
- [ ] Note the settlement cycle so `payment.captured` timing expectations are realistic.

---

## 11. Test Plan

### Test-mode credentials

| Field | Value |
|---|---|
| Key id | `rzp_test_*` from the dashboard |
| UPI success VPA | `success@razorpay` |
| UPI failure VPA | `failure@razorpay` |
| Webhook local tunnel | ngrok / cloudflared → `/api/v1/payments/webhook` |

### Matrix

| # | Scenario | Expected |
|---|---|---|
| 1 | Mandate registration happy path (`success@razorpay`) | Order created, Checkout opens in recurring mode, `payment.captured` + `token.confirmed` land, `razorpayTokenId` + `razorpayCustomerId` stored, subscription ACTIVE, CouponBook created, coins awarded, referral fulfilled |
| 2 | User rejects the mandate in the UPI app | `token.rejected` / `payment.failed`, `PaymentAttempt` FAILED, no subscription |
| 3 | User dismisses Checkout | `EVENT_PAYMENT_ERROR`, controller shows cancelled, `PaymentAttempt` stays PENDING |
| 4 | Duplicate webhook (replay the same `x-razorpay-event-id`) | second delivery is a no-op |
| 5 | Tampered webhook body / wrong signature | rejected + logged, nothing fulfilled |
| 6 | App killed right after MPIN | webhook fulfils server-side; reopening the app shows ACTIVE |
| 7 | `/verify` called before the webhook arrives | signature verified, optimistic fulfilment, and the later webhook is idempotent |
| 8 | Renewal debit succeeds | `create/recurring` → `payment.captured` (24–36 h) → `endDate` extended, new CouponBook, coins, `renewalFailureCount = 0` |
| 9 | Renewal debit fails (insufficient funds) | `payment.failed`, `renewalFailureCount++`, retried next day |
| 10 | Renewal fails 3× | subscription EXPIRED, `isAutopayEnabled = false`, re-subscribe push |
| 11 | User revokes the mandate in their bank app | `token.cancelled` → `isAutopayEnabled = false`, push sent |
| 12 | In-app "Cancel autopay" | token cancelled at Razorpay, flag false, renewal job skips the user |
| 13 | Renewal job runs twice in a day | the PENDING-RENEWAL guard prevents a second debit |
| 14 | Admin raises `subscription_price` | next renewal debits the new amount, as long as it is ≤ `max_amount`; no re-registration |
| 15 | Admin raises the price **above** `max_amount` | debit rejected — confirm the failure is visible and the user is prompted |
| 16 | Amount rounding (`₹999.50`) | order amount is exactly `99950` paise everywhere; no float drift |
| 17 | Android 11+ device, GPay installed | UPI intent app-switch works (`<queries>` present) |
| 18 | iOS device | UPI app switch works after the `LSApplicationQueriesSchemes` additions |
| 19 | Release build (R8/ProGuard on) | Checkout opens — verifies the new keep rules |
| 20 | Test → Live key swap | test keys rejected in live, live webhook secret configured separately |

---

## 12. Rollout & Rollback

**Order of operations**

1. Razorpay dashboard setup (§10) — do first, it has approval lead time (UPI Autopay activation is a support
   ticket, not instant).
2. Backend on a feature branch; deploy to staging with test keys; run the §11 matrix end-to-end.
3. Take a production DB backup; apply the Prisma migration (§8.2 — no archival step needed per §9).
4. Deploy backend with live Razorpay keys; PayU config/env removed in the same deploy.
5. Ship the Flutter build. **Force-update it.** An old build calls `/payments/generate-hash`, which no longer
   exists — those users cannot pay at all. Bump the minimum supported version, or keep `/generate-hash`
   alive returning a "please update" error for one release cycle.
6. Admin type cleanup + optional payments view.

No user-notification or mandate-revoke step — §9 confirms there is nothing live to migrate away from.

**Rollback.** The migration drops columns, so a code-only rollback does **not** restore PayU. Rolling back means
restoring the DB backup and redeploying the previous build. Since there's no production PayU traffic to protect,
the usual "keep the backup for a full renewal cycle" caution is about protecting *new* Razorpay data captured
after cutover, not PayU data.

---

## 13. File-Change Summary

### CouponAPI

| Action | File |
|---|---|
| **DELETE** | `src/config/payu.ts` |
| **DELETE** | `src/shared/utils/payuHash.ts` |
| **NEW** | `src/config/razorpay.ts` |
| **NEW** | `src/shared/utils/razorpaySignature.ts` |
| **REWRITE** | `src/modules/payments/payments.service.ts` |
| **REWRITE** | `src/modules/payments/payments.controller.ts` |
| **REWRITE** | `src/modules/payments/payments.routes.ts` |
| **REWRITE** | `src/modules/payments/payments.validator.ts` |
| **REWRITE** | `src/modules/payments/payments.swagger.ts` |
| **REWRITE** | `src/jobs/recurringDebits.job.ts` |
| **EDIT** | `src/config/env.ts` — swap the PayU block for the Razorpay block |
| **EDIT** | `src/app.ts` — resolve the raw-body/webhook parser overlap (§5.6) |
| **EDIT** | `src/server.ts` — actually schedule `scheduleRecurringDebits()` |
| **EDIT** | `src/database/seed.ts:207` |
| **EDIT** | `prisma/schema.prisma` + new migration |
| **EDIT** | `.env.example` |
| **EDIT** | `package.json` — add `razorpay` |
| **DELETE** | `../PAYU_UPI_AUTOPAY_INTEGRATION.md`, `razorpay_implementation_plan.md` (superseded) |

### CouponCustomer

| Action | File |
|---|---|
| **DELETE** | `lib/core/services/payu_service.dart` |
| **NEW** | `lib/core/services/razorpay_service.dart` |
| **REWRITE** | `lib/features/payment/data/payment_repository.dart` |
| **REWRITE** | `lib/features/payment/presentation/payment_controller.dart` |
| **EDIT** | `lib/core/di/injection.dart:39,68` |
| **EDIT** | `lib/core/config/app_config.dart` — remove `payuMerchantKey` |
| **EDIT** | `lib/main.dart:14` — doc comment |
| **EDIT** | `pubspec.yaml:39` |
| **EDIT** | `lib/features/subscription/data/models/payment_history_model.dart` + regenerate freezed/`.g.dart` |
| **REWRITE** | `lib/features/subscription/presentation/my_subscriptions_screen.dart` — replace mocks with real API calls |
| **EDIT** | `lib/features/subscription/presentation/screens/purchase_screen.dart` — copy, logos, mandate consent, call-site signature |
| **EDIT** | `android/app/src/main/AndroidManifest.xml` |
| **EDIT** | `android/app/proguard-rules.pro` |
| **EDIT** | `ios/Runner/Info.plist` — `LSApplicationQueriesSchemes` |

### CouponAdmin

| Action | File |
|---|---|
| **EDIT** | `src/types/api/users.ts:47-57` — fix the stale `UserSubscription` gateway fields |
| **NEW** *(optional)* | Payments/Subscriptions admin page + `GET /admin/payments` endpoint |

---

## 14. Decisions Log (was: Open Questions)

All seven items below were open questions in the first draft. Answers are in; §2, §5, §9 already reflect them.
This section is now a record of what was decided and why, not a blocker list.

1. **Mandate cancellation endpoint** → **Resolved from the installed SDK's type defs** (`node_modules/razorpay`
   v2.9.8): `customers.deleteToken(customerId, tokenId)` → `DELETE /customers/{customer_id}/tokens/{token_id}` →
   `Promise<{ deleted: boolean }>`. That's the call `cancelAutopay` uses. No separate UPI-specific
   mandate-cancel endpoint exists in this SDK version.
2. **`max_amount`** → **₹5,000** (`500000` paise). Applied in §2 and §5.2's env default.
3. **`frequency`** → **`"monthly"`**, not `as_presented`. Applied in §2 and §5.5's order-creation snippet; safe
   because renewals fire ~45–50 days apart, i.e. under one debit per calendar month.
4. **Auto-capture** → confirmed `payment_capture: true` on the order suffices; no extra capture call in
   `create/recurring`. No code change needed — §5.5 already assumed this.
5. **`token.confirmed` vs `payment.captured` ordering** → confirmed as a design call, not a doc fact. §5.5's
   `handleWebhook` already treats `onTokenConfirmed` and `onPaymentCaptured` as independent, either-order-safe
   handlers — keep it that way.
6. **`notes` propagation fallback** → accepted as designed; `PaymentAttempt` lookup by `razorpayOrderId` stays as
   the fallback path in §5.5.
7. **PayU mandate revoke** → **moot.** Zero clients onboarded via PayU in production. §9 rewritten to a
   straight code-and-schema swap with no revoke/notify phase.

---

## Reference docs

- [Razorpay Recurring Payments — UPI Autopay](https://razorpay.com/docs/payments/recurring-payments/upi/)
- [Recurring Payments APIs for UPI](https://razorpay.com/docs/payments/recurring-payments/upi/apis/)
- [Create Subsequent Payments](https://razorpay.com/docs/partners/aggregators/partner-auth/recurring-payments/upi/create-subsequent-payments/)
- [Create Authorisation Transaction](https://razorpay.com/docs/partners/aggregators/partner-auth/recurring-payments/upi/create-authorisation-transaction/)
- [UPI Autopay — S2S integration](https://razorpay.com/docs/payments/payment-gateway/s2s-integration/recurring-payments/upi/)
- [Subscriptions overview](https://razorpay.com/docs/payments/subscriptions/) · [Subscriptions API](https://razorpay.com/docs/api/payments/subscriptions/)
- [Subscription webhook payloads](https://razorpay.com/docs/webhooks/payloads/subscriptions/)
- [`razorpay_flutter` on pub.dev](https://pub.dev/packages/razorpay_flutter)
