# CouponAPI — Implementation Plan

A phased, end-to-end build plan for the CouponAPI backend. Follows the approved tech stack (Node.js 20 + TypeScript + Express + Prisma + PostgreSQL + Redis + BullMQ + MSG91 + Razorpay + OneSignal).

---

## Phase 0 — Project Foundation

Everything else depends on this phase being correct. **Must complete before any module work.**

### Structure Restructure
Migrate from the current flat-layer layout to domain-grouped:

#### [MODIFY] [src/app.ts](file:///e:/CouponApp/CouponAPI/src/app.ts)
- Import routes from `src/modules/*/routes` instead of current `src/routes/index.ts`
- Update middleware imports from `src/shared/middlewares/`

#### [MODIFY] [src/server.ts](file:///e:/CouponApp/CouponAPI/src/server.ts)
- Import `redis` client and ensure graceful disconnect on shutdown

#### [NEW] src/config/redis.ts
- `ioredis` client instance, exported as singleton

#### [NEW] src/shared/middlewares/ *(move existing)*
- Move `auth.ts`, `errorHandler.ts`, `security.ts`, `validate.ts` here

#### [NEW] src/shared/utils/ *(move existing)*
- Move `AppError.ts`, `response.ts` here
- Add: `jwt.ts` (sign/verify helpers), `qrcode.ts` (QR token generator)

#### [NEW] src/shared/types/
- `express.d.ts` — extend `Request` with `user` (role-aware: customer | seller | admin)
- `pagination.ts` — shared pagination query type

---

### Prisma Schema

#### [MODIFY] prisma/schema.prisma *(new file)*
All models in dependency order:

```
City → Area → Seller → Coupon → CouponBook → UserCoupon → Redemption
User → Subscription → WalletTransaction
Settlement → SettlementLine
NotificationLog
AppSetting
```

**Key models:**
- `City` (id, name, status: Enum(ACTIVE | COMING_SOON))
- `Area` (id, name, cityId, isActive: Boolean)
- `User` (id, phone, name, email, cityId, areaId, status: Enum(ACTIVE | BLOCKED))
- `Subscription` (id, userId, startDate, endDate, status: Enum(ACTIVE | EXPIRED))
- `WalletTransaction` (id, userId, type: Enum(EARNED | USED), amount, redemptionId?, note)
- `Seller` (id, businessName, category: Enum(FOOD | SALON | THEATER | SPA | CAFE | OTHER), cityId, areaId, phone, upiId, lat, lng, status: Enum(PENDING | ACTIVE | SUSPENDED), commissionPct)
- `Coupon` (id, sellerId, discountPct, adminCommissionPct, minSpend?, maxUsesPerBook, type: Enum(STANDARD | BOGO), status: Enum(ACTIVE | INACTIVE))
- `CouponBook` (id, subscriptionId, userId, validFrom, validUntil)
- `UserCoupon` (id, couponBookId, couponId, usesRemaining, status: Enum(ACTIVE | USED | EXPIRED))
- `Redemption` (id, userCouponId, sellerId, userId, billAmount, discountAmount, coinsUsed, finalAmount, redeemedAt)
- `Settlement` (id, sellerId, weekStart, weekEnd, status: Enum(PENDING | PAID), commissionTotal, coinCompensationTotal, commissionPaidAt?, coinPaidAt?)
- `NotificationLog` (id, type, targetType, targetId, message, sentAt)
- `AppSetting` (id, key, value) — key-value store for admin-configurable settings
- `RefreshToken` (stored in Redis, not Prisma)
- `Otp` (stored in Redis, not Prisma)

---

## Phase 1 — Auth Module

**Path:** `src/modules/auth/`

#### [NEW] auth.routes.ts
- `POST /api/v1/auth/send-otp`
- `POST /api/v1/auth/verify-otp`
- `POST /api/v1/auth/admin/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`

#### [NEW] auth.controller.ts → auth.service.ts → auth.validator.ts

**Key logic in service:**
- `sendOtp`: Generate 6-digit OTP → store in Redis with `otp:{phone}` key, 5-min TTL → send via MSG91 REST API
- `verifyOtp`: Fetch from Redis → compare → delete → return JWT pair (access: 24h, refresh: 7d stored in Redis)
- `adminLogin`: bcrypt compare → return JWT pair with role `admin`
- `refresh`: Verify refresh token in Redis → issue new access token
- `logout`: Delete refresh token from Redis

---

## Phase 2 — City & Area Module

**Path:** `src/modules/admin/cities/`

#### [NEW] cities.routes.ts
- `GET /api/v1/admin/cities`
- `POST /api/v1/admin/cities`
- `PATCH /api/v1/admin/cities/:id`
- `GET /api/v1/admin/cities/:cityId/areas`
- `POST /api/v1/admin/cities/:cityId/areas`
- `PATCH /api/v1/admin/areas/:id`

All routes: `authenticate + authorize('admin')`

---

## Phase 3 — Users Module

**Path:** `src/modules/users/`

#### [NEW] users.routes.ts
- `POST /api/v1/users/register` — save user after OTP verified; auto-detect city/area from lat/lng if available, else from request body
- `GET /api/v1/users/me`
- `PATCH /api/v1/users/me`
- `GET /api/v1/users/me/qr` — returns a short-lived JWT-signed QR token (5-min TTL), and the QR image as base64

**Admin sub-routes** (`src/modules/admin/users/`):
- `GET /api/v1/admin/users` — list with filters (city, area, status, search)
- `GET /api/v1/admin/users/:id` — full profile with subscription + redemption + wallet history
- `PATCH /api/v1/admin/users/:id/block`
- `POST /api/v1/admin/users/:id/coins` — manually award coins + log a `WalletTransaction`

---

## Phase 4 — Sellers Module

**Path:** `src/modules/sellers/`

#### [NEW] sellers.routes.ts
- `POST /api/v1/sellers/register`
- `GET /api/v1/sellers/me`
- `PATCH /api/v1/sellers/me`
- `GET /api/v1/sellers` — list sellers in user's city, sorted by distance (uses `lat`, `lng`, Haversine formula)
- `GET /api/v1/sellers/me/dashboard`

**Admin sub-routes:**
- `GET /api/v1/admin/sellers` — filters: city, area, category, status
- `PATCH /api/v1/admin/sellers/:id/approve`
- `PATCH /api/v1/admin/sellers/:id/suspend`
- `PATCH /api/v1/admin/sellers/:id` — edit details, commission

---

## Phase 5 — Payments Module (Razorpay)

**Path:** `src/modules/payments/`

#### [NEW] payments.routes.ts
- `POST /api/v1/payments/create-order` — creates Razorpay order, returns `orderId` + `amount` to mobile app
- `POST /api/v1/payments/webhook` — raw body, HMAC signature verified via middleware

#### [NEW] razorpayWebhook.middleware.ts (in shared/middlewares)
- Verify `x-razorpay-signature` header using `crypto.createHmac`

**On successful webhook `payment.captured` event:**
1. Create `Subscription` record
2. Create `CouponBook` record with all city base coupons
3. Create `UserCoupon` records from the base coupon set
4. Credit coins via `WalletTransaction` (amount from `AppSetting`)
5. Trigger `coin_credited` OneSignal push notification

---

## Phase 6 — Coupons Module

**Path:** `src/modules/coupons/`

#### [NEW] coupons.routes.ts
- `GET /api/v1/coupons` — user's own active `UserCoupon` list (filtered by category)
- `GET /api/v1/coupons/seller/:sellerId` — all active coupons from a seller (for Seller app)

**Admin sub-routes:**
- `POST /api/v1/admin/coupons`
- `PATCH /api/v1/admin/coupons/:id`
- `PATCH /api/v1/admin/coupons/:id/deactivate` — sets `Coupon.status = INACTIVE`; related `UserCoupon` records auto-excluded via query filter
- `GET /api/v1/admin/cities/:cityId/base-coupons` — manage the base coupon set for a city
- `POST /api/v1/admin/cities/:cityId/base-coupons`

---

## Phase 7 — Redemptions Module

**Path:** `src/modules/redemptions/`

#### [NEW] redemptions.routes.ts
- `POST /api/v1/redemptions/scan` — Seller scans user QR token → validates JWT → returns user name, subscription status, + eligible `UserCoupon` list at this seller
- `POST /api/v1/redemptions/confirm` — Seller confirms redemption; atomic transaction:
  1. Decrement `UserCoupon.usesRemaining`
  2. Deduct coins from wallet if `coinsUsed > 0` (validate against `AppSetting.maxCoinsPerTransaction`)
  3. Create `Redemption` record
  4. Upsert `Settlement` for this seller/week
  5. Push `redemption_confirmation` notification to user
- `GET /api/v1/redemptions/history` — user's redemption log (filters: this_week, this_month, all)
- `GET /api/v1/sellers/me/redemptions` — seller's redemption log

> ⚠️ `confirmRedemption` must be a **Prisma transaction** to ensure atomicity of coin deduction + redemption log + settlement update.

---

## Phase 8 — Wallet Module

**Path:** `src/modules/wallet/`

#### [NEW] wallet.routes.ts
- `GET /api/v1/users/me/wallet` — balance + full `WalletTransaction` history

**Admin sub-routes:**
- `GET /api/v1/admin/wallet/settings`
- `PATCH /api/v1/admin/wallet/settings` — `coinsPerSubscription`, `maxCoinsPerTransaction`
- `POST /api/v1/admin/wallet/bulk-award` — award coins to all users in a city or globally
- `GET /api/v1/admin/wallet/overview` — total platform coin liability

---

## Phase 9 — Settlements Module

**Path:** `src/modules/settlements/`

#### [NEW] settlements.routes.ts
- `GET /api/v1/sellers/me/settlements` — week-by-week list of commission + coin compensation owed
- `GET /api/v1/sellers/me/settlements/week/:weekId/summary` — detail breakdown
- `GET /api/v1/admin/settlements` — all sellers with pending settlement
- `PATCH /api/v1/admin/settlements/:id/mark-paid` — mark commission + optional coin comp as paid; body: `{ commissionPaid: true, coinCompPaid: true }`
- `GET /api/v1/admin/settlements/export` — returns CSV (async BullMQ job, returns download URL)

**Settlement record auto-created/updated** by the Redemption confirmation flow (Phase 7).

---

## Phase 10 — Analytics Module

**Path:** `src/modules/analytics/`

All routes: `authenticate + authorize('admin')`

#### [NEW] analytics.routes.ts
- `GET /api/v1/admin/analytics/subscriptions` — daily/weekly/monthly revenue (filter: cityId, date range)
- `GET /api/v1/admin/analytics/redemptions` — redemptions over time (filter: city, category, seller)
- `GET /api/v1/admin/analytics/sellers/top` — top 10 by redemption count
- `GET /api/v1/admin/analytics/coupons/top` — top 10 most redeemed coupons
- `GET /api/v1/admin/analytics/coins` — coins awarded vs used, top coin users
- `GET /api/v1/admin/analytics/churn` — users who did not renew after expiry

All endpoints use Prisma aggregation queries (`groupBy`, `count`, `sum`).

---

## Phase 11 — Notifications Module

**Path:** `src/modules/notifications/` + `src/jobs/`

#### [NEW] onesignal.service.ts
- `sendToUser(userId, title, body)` — tag-based targeting
- `sendToCity(cityId, title, body)` — filter by city tag
- `sendToSegment(filter, title, body)` — generic segment push

#### [NEW] notifications.routes.ts
- `POST /api/v1/admin/notifications/send` — manual push (target: user | city | global)
- `GET /api/v1/admin/notifications/history`

#### [NEW] src/jobs/expiryReminderJob.ts (BullMQ)
- Runs daily at 9 AM IST
- Finds all subscriptions expiring in exactly 7 days → push notification
- Finds all subscriptions expiring in exactly 2 days → push notification

#### [NEW] src/jobs/dailyMotivationJob.ts (BullMQ)
- Runs daily at 10 AM IST
- Push to all active subscribers

---

## Phase 12 — App Settings Module

**Path:** `src/modules/admin/settings/`

#### [NEW] settings.routes.ts
- `GET /api/v1/admin/settings`
- `PATCH /api/v1/admin/settings`

Manages `AppSetting` table (key-value). Keys:
- `subscription_price`
- `book_validity_days`
- `coins_per_subscription`
- `max_coins_per_transaction`
- `expiry_reminder_template_7d`
- `expiry_reminder_template_2d`

---

## Phase 13 — Admin & Seller Dashboards

#### [NEW] admin.dashboard.routes.ts
- `GET /api/v1/admin/dashboard`
  - Active subscriber count
  - Revenue this month
  - Today's + this week's redemptions
  - Pending settlement count
  - Pending seller approvals count
  - Coins awarded this month + pending coin compensation

#### [NEW] seller.dashboard.routes.ts (Seller App)
- `GET /api/v1/sellers/me/dashboard`
  - Today's + this week's redemption count
  - Commission owed to admin this week
  - Coin compensation receivable from admin this week

---

## Phase 14 — Final Polish

- [ ] Swagger UI setup at `GET /api/docs`
- [ ] Pagination (`page`, `limit`, `total`, `totalPages`) on all list endpoints
- [ ] Search: `GET /api/v1/sellers?search=` and `GET /api/v1/coupons?search=`
- [ ] Verify correct HTTP status codes and consistent `{ success, data, meta? }` response shape everywhere

---

## Verification Plan

> No automated tests for MVP. Manual verification using a REST client (e.g., **Postman** or **Thunder Client** in VS Code).

### Setup
```bash
# 1. Start dev stack
docker-compose up -d          # starts PostgreSQL + Redis

# 2. Run migrations
npx prisma migrate dev

# 3. Seed base data (cities, areas, admin user)
npx ts-node src/database/seed.ts

# 4. Start dev server
npm run dev
```

### Manual Test Flows (per Phase)

#### Phase 0 — Health Check
```
GET http://localhost:3000/health
→ Expected: { status: "ok" }
```

#### Phase 1 — Auth
```
POST /api/v1/auth/send-otp     { phone: "9999999999" }
POST /api/v1/auth/verify-otp   { phone: "9999999999", otp: "123456" }
→ Expected: { accessToken, refreshToken }
POST /api/v1/auth/admin/login  { email: "admin@couponapp.in", password: "..." }
```

#### Phase 5 — Payments
- Create a Razorpay test order → simulate webhook call manually using Razorpay test dashboard
- Verify: Subscription created, CouponBook populated, coins credited, push notification sent

#### Phase 7 — Redemption Flow (Critical)
1. Register a user → purchase subscription
2. Register a seller (approve via admin)
3. Generate user QR: `GET /api/v1/users/me/qr`
4. Seller scans: `POST /api/v1/redemptions/scan` with QR token
5. Seller confirms: `POST /api/v1/redemptions/confirm` with couponId, billAmount, coinsUsed
6. Verify: UserCoupon.usesRemaining decremented, WalletTransaction created (if coins used), Redemption record created, Settlement updated

#### Phase 9 — Settlements
- After redemption in Phase 7, check `GET /api/v1/admin/settlements`
- Mark as paid: `PATCH /api/v1/admin/settlements/:id/mark-paid`
- Verify `Settlement.status` changes to PAID

#### Phase 11 — BullMQ Jobs
```bash
# Use bullmq's dashboard (bull-board) or manually trigger the job:
npx ts-node -e "import('./src/jobs/expiryReminderJob').then(j => j.triggerNow())"
```
- Verify OneSignal dashboard shows the push was sent

---

## Dependency Order Summary

```
Phase 0  →  Phase 1  →  Phase 2  →  Phase 3
                    ↓
              Phase 4  →  Phase 5  →  Phase 6
                                 ↓
                           Phase 7  →  Phase 8
                                  ↓
                            Phase 9  →  Phase 10
                                        ↓
                                  Phase 11 → Phase 12 → Phase 13 → Phase 14
```

Each phase adds endpoints that future phases depend on. **Never skip Phase 0.**
