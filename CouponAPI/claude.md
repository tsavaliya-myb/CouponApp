# Coupon App — Project Brief

## What is This App?

A coupon book platform launching in Surat, India, designed to expand to multiple cities across India over time. Users pay ₹1000 (this can be any amount) to get a coupon book valid for 45-50 days. The book contains discount coupons redeemable at partner restaurants, salons, theaters, and other businesses. When a coupon is redeemed, the user gets a discount on their bill and pays the seller directly. The platform earns from two sources — the ₹1000 subscription fee from users, and a hidden commission from sellers on every redemption.

## Geographic Structure

The platform is built around a two-level location hierarchy: City → Area. Every seller, coupon, and user belongs to a city first, and an area within that city second. This structure supports the current single-city launch in Surat while being ready for expansion to new cities without any redesign.

- City — the top-level geographic unit (e.g. Surat, Ahmedabad, Vadodara)
- Area — a neighbourhood or zone within a city (e.g. Adajan, Vesu, Katargam within Surat)

All filtering, coupon assignment, seller discovery, and user onboarding is aware of both city and area.

---

## Three Parties

### 1. Customer (User)
A resident of any supported city who buys the ₹1000 coupon book and redeems coupons at partner businesses within their city.

### 2. Seller (Business Partner)
A restaurant, salon, theater, spa, cafe, or any local business in a supported city that offers discounts to coupon book holders. Every seller belongs to one city and one area within that city.

### 3. Admin (Platform Owner)
The person who runs the platform. Creates and manages everything — coupons, sellers, users, commission settlements, and wallet/coin operations.

---

## How Commission Works

- Seller offers a total discount of X% (e.g. 25%)
- User sees and gets a lower discount (e.g. 20%)
- The difference (e.g. 5%) is the admin's hidden commission
- User never knows about the admin's commission
- Commission percentage varies per seller and per coupon — admin sets it manually
- Admin collects commission from sellers manually every week
- Admin marks each settlement as paid in the system

---

## Wallet & Coin System

The platform includes a built-in coin wallet for users. Coins act as cashback rewards and can be redeemed at the time of payment to reduce the final bill.

### Coin Rules
- 1 Coin = ₹1
- After a successful subscription purchase, admin awards a set number of coins to the user (amount is configurable by admin)
- Maximum coins usable per transaction: 10 coins (editable by admin)
- Coins are deducted only when a user voluntarily chooses to apply them at checkout
- Coin balance carries forward across book renewals

### Coin Redemption Flow
1. User visits seller physically and begins the coupon redemption process
2. Seller asks the user if they want to apply coins
3. If user agrees and has available coins, the app applies up to the maximum allowed (e.g. 10 coins = ₹10 off)
4. Final bill amount is reduced by the coin value applied
5. User pays the reduced final amount to the seller
6. Coin deduction is recorded in the user's wallet and reflected in the redemption log

### Coin Settlement
When coins are used during a transaction, the seller gives an additional discount of ₹1 per coin to the user. Admin compensates the seller for this during the weekly manual settlement.

- Coin compensation is displayed as a separate line item in both the seller app and admin panel settlement screens
- Admin marks coin compensation as settled alongside the regular commission payment
- Both parties can clearly see the breakdown: commission owed vs coin compensation owed

### Admin Coin Settings
- Set coins awarded per subscription purchase (configurable)
- Set maximum coins usable per transaction (default: 10, editable)

---

## Coupon Book Structure

### Base Coupons
Every user in a city gets the same set of base coupons for that city. Base coupons are city-specific — a Surat user gets Surat base coupons, an Ahmedabad user gets Ahmedabad base coupons. Admin manages a separate base coupon set per city.

### Validity
The entire coupon book expires after 45-50 days (editable). When expired, user must pay ₹1000 again to get a new book. All unused coupons expire with the book — no carry forward.

### Renewal
Users get notified 5-7 days before expiry. After expiry the app shows a renewal screen and user cannot redeem any coupon until they renew.

---

## Customer App — Full Functionality

### Onboarding
- Register with phone number
- Verify phone with OTP
- App will ask for some permissions (Location, Notification, Camera etc.)
- Will decide user's city and area based on location
- Land on Home screen

### Subscription Purchase
- See ₹1000 plan details — validity, number of coupons, list of benefits
- Pay ₹1000 via Razorpay (UPI, card, wallet all supported)
- On success, coupon book is immediately activated
- Shown expiry date and total coupons unlocked
- Coins are credited to user's wallet after successful purchase (amount set by admin)

### Home Screen
- Greeting with user name
- Category quick-filter row (All, Food, Salon, Theater, Spa, Cafe)
- Vertical scroll of user's own active coupons
- Non-paid users see some coupons and some blurred coupons to encourage purchase
- Vertical list of sellers in user's city, sorted by distance and area proximity
- Search bar to find sellers or coupons by name within the user's city
- Profile icon on far right top corner beside search bar

### My Coupons Screen
- Three tabs: Active, Used, Expired
- Active tab shows all redeemable coupons in ticket-style cards
- Each card shows: discount %, seller name, area, uses remaining, expiry
- Used tab shows redeemed coupons with date and amount saved
- Expired tab shows expired coupons from past books

### Wallet Screen *(New)*
- Coin balance prominently displayed at top
- Transaction history: coins earned, coins used, date and context for each entry
- Each entry shows: event type (earned / used), amount, seller name if used, date and time
- Lifetime coins earned and lifetime coins redeemed summary stats

### Coupon Redemption Flow
- User visits a seller location physically
- User opens app and goes to QR Code screen
- A large profile QR code is displayed — this is the user's identity QR
- User shows this QR to the seller
- Seller scans the QR using their app
- Seller's app shows the user's name and subscription status
- Seller asks user which coupon to apply
- User confirms verbally
- Seller selects the coupon from their app
- Seller enters the total bill amount
- Seller asks user if they want to apply coins
- If user agrees and has available coins, coins (up to the max limit) are deducted and final amount is reduced accordingly
- Seller's app shows: bill amount, coupon discount applied, coins applied (if any), final amount to pay
- User pays the final amount directly to the seller (cash or UPI)
- Seller's app will generate UPI QR code for the final amount if user pays via UPI
- User scans the UPI QR code and pays the final amount
- Seller confirms redemption in their app
- User's app updates — coupon marked as used, uses remaining decremented, coin balance updated

### Profile QR Screen
- Displays a large QR code unique to the user
- QR is always visible as long as subscription is active
- QR cannot be used if subscription is expired
- Refreshes periodically for security

### Redemption History
- List of all past redemptions
- Each entry shows: seller name, coupon used, coins used, date and time, amount saved
- Filterable by this week, this month, all time

### Notifications
- Expiry reminder 7 days before book expires
- Expiry reminder 2 days before book expires
- New coupon added to platform alert
- Redemption confirmation after each use
- Renewal success confirmation
- Daily notification to motivate users to use coupons
- Coin credited notification when admin awards coins after subscription purchase

### Profile & Settings
- View and edit name, phone, city, area, email
- Changing city resets area selection to areas within the new city
- View current subscription status and expiry
- View total savings since joining
- View wallet coin balance (shortcut link to Wallet screen)
- Help and support with FAQ
- Logout

---

## Seller App — Full Functionality

### Onboarding
- Register with business name, category, city, area, address, phone, email, days availability, time availability, UPI ID, location
- City and area selected based on location (manual selection if permission denied)
- Seller can have multiple outlets under same business name across different areas or cities — all must be registered and verified
- Submit business details for admin approval
- Wait screen showing pending approval status
- Notified when approved and activated

### Dashboard
- Today's redemption count
- This week's redemption count
- Commission owed to admin this week
- Coin compensation receivable from admin this week (separate line item)
- Quick action button to scan a coupon

### Coupon Redemption Flow (Seller Side)
1. Tap Scan button to open camera
2. Scan user's profile QR
3. App shows user's name and confirms subscription is active
4. If subscription is expired or invalid — show error, cannot proceed
5. List of coupons applicable at this seller appears
6. Seller selects the coupon the user wants to use
7. If coupon has minimum spend requirement — shown clearly
8. Seller enters the total bill amount
9. App calculates and shows: discount amount, subtotal after coupon
10. Seller asks user if they want to apply coins. If yes and user has coins, app shows coin deduction and updated final amount
11. Seller taps Confirm — redemption is logged, coin deduction recorded
12. Success screen shown — seller gives discount to user
13. User pays discounted amount (minus any coins) directly to seller

### Redemption Log
- Full history of all redemptions at this seller
- Each entry: user name (masked for privacy), coupon, bill amount, coins used, date, time
- Filter by today, this week, this month

### Weekly Summary
- Total redemptions this week
- Breakdown per coupon type
- Total commission owed to admin
- Total coin compensation receivable from admin (coins used at this seller this week × ₹1)
- Clear display to make weekly settlement easy

### Settlement Screen
- Week-by-week list of commission amounts owed
- Each week shows: total redemptions, commission amount, status (pending or paid)
- Each week also shows: total coins used, coin compensation amount from admin, settlement status for coin compensation
- Admin marks both commission and coin compensation as paid — seller sees updated status

### Business Profile
- Edit business name, city, area, address, operating hours
- City and area are editable but require admin re-approval if changed
- Location needed to show distance from user
- Update UPI ID or bank details for their own records
- View approval status

---

## Admin Panel — Full Functionality

### Dashboard
- Total active subscribers (users with live coupon book)
- Total revenue this month (subscriptions + estimated commission)
- Total redemptions today and this week
- Pending commission settlements count
- Total coins awarded this month and total coin compensation pending
- New seller registration requests count
- Quick action buttons for common tasks

### User Management
- View all registered users with subscription status
- Search by name or phone number
- Filter by city, area, subscription status (active/expired), join date
- View individual user profile — subscription history, redemption history, wallet/coin transaction history
- Block or unblock a user
- Award coins to a user manually — enter amount and optional note (e.g. "Welcome bonus", "Renewal reward")
- View full coin ledger per user: coins earned, coins used, current balance
- Send push notification to individual user, all users in a city, or all users globally
- Export user list as CSV

### Seller Management
- View all seller registrations — pending, active, suspended
- Filter by city, area, category, status
- Approve or reject new seller registrations
- Set commission percentage per seller (default for all coupons of that seller)
- Edit seller details — name, category, city, area, commission
- Suspend a seller (all their coupons become inactive immediately)
- Reactivate a suspended seller
- View seller's full redemption history and commission history
- View coin usage history at each seller (coins used, total coin compensation owed)
- Search and filter sellers by city, category, area, status

### Coupon Management
- Create a new coupon
  - Select which seller it belongs to
  - Set the discount percentage the user will see (e.g. 20%)
  - Set admin commission percentage (default 5%) — hidden from user
  - Set minimum spend amount (optional)
  - Set maximum uses per user per book validity period
  - Set active/inactive status
  - Buy one get one coupon (also able to create other types of coupons)
- Edit any existing coupon at any time
- View coupon performance — total redemptions, total commission generated
- Deactivate a coupon instantly — it disappears from all user books immediately

### Coupon Book Management
- Define base coupon set per city — different cities can have different base coupons
- Set book validity in days (45-50 day range)
- Changes to the book apply to new purchases — existing active books are unaffected

### Settlement Management
- View all sellers with pending commission this week
- Per seller breakdown — list of redemptions, bill amounts, commission per redemption
- Total commission owed per seller
- Coin compensation column per seller: total coins used at that seller this week, total amount admin owes seller
- Mark commission payment and coin compensation payment separately or together as settled
- View full settlement history week by week
- Export settlement report as PDF or CSV for accounting

### Wallet Management *(New)*
- Set coins awarded per subscription purchase (configurable amount)
- Set maximum coins usable per transaction (default: 10, editable)
- View all coin transactions across the platform — awarded, used, filtered by city and date
- Bulk award coins to all users in a city or globally (e.g. for promotions)
- View total platform coin liability (total outstanding coins across all user wallets)

### Analytics
- Subscription revenue chart — daily, weekly, monthly (filterable by city)
- Total users over time — growth chart per city and overall
- Redemptions over time — by city, category, seller
- Top 10 sellers by redemption count (filterable by city)
- Top 10 most used coupons (filterable by city)
- Churn rate — users who did not renew after expiry
- City-wise performance — compare revenue and activity across cities
- Area-wise activity within a city — which neighbourhoods are most active
- Commission earned over time — by city and overall
- Coin analytics — total coins awarded vs used, coin-to-revenue impact, top coin users

### Notification Management
- Send push notification to all users globally
- Send push notification to all users in a specific city
- Send push notification to users in a specific area within a city
- Send push notification to users whose subscription expires in X days
- Send push notification to users when coins are credited to their wallet
- View notification history and delivery stats
- Automated notification every day before a week when subscription is about to expire

### City & Area Management
- View all cities on the platform — active and coming soon
- Add a new city to the platform
- Set city status: Coming Soon or Active
- Edit city name and status
- Add areas within a city
- Edit or deactivate areas within a city
- Deactivating an area hides it from new registrations but does not affect existing users
- Area list is always scoped under a city — same area name can exist in multiple cities independently

### App Settings
- Set subscription price (currently ₹1000) — can be set differently per city in future
- Set book validity days (currently 45-50)
- Edit notification message templates (expiry reminder text, welcome message text etc.)
- Set coins awarded per subscription purchase (default: configurable)
- Set maximum coins usable per transaction (default: 10)

---

## Key Business Rules

1. A user cannot redeem any coupon if their subscription is expired
2. A coupon can only be redeemed at the specific seller it belongs to
3. Each coupon has a maximum use limit per user per validity period (set by admin)
4. If a coupon has minimum spend, seller cannot confirm redemption if bill is below that amount
5. Admin can change a coupon's seller, discount, or commission at any time — changes apply going forward
6. When admin deactivates a coupon, it disappears from all user books immediately
7. When admin suspends a seller, all coupons of that seller become unredeemable immediately
8. Seller pays admin commission weekly via manual bank transfer — admin marks it paid
9. User pays the seller directly for the service — platform does not handle this payment
10. The only payment the platform handles is the ₹1000 subscription via Razorpay
11. User's profile QR is their identity — it works for any coupon at any seller within their city
12. Unused coupons expire with the book — no carry forward to next book
13. Commission percentage is hidden from users at all times
14. Every coupon belongs to a seller — and therefore inherits that seller's city and area
15. Users only see coupons and sellers from their own registered city
16. Base coupons are defined per city — different cities have different base coupon sets
17. Areas are always scoped under a city — admin manages areas per city independently
18. A city must be marked Active by admin before users in that city can purchase subscriptions
19. 1 coin = ₹1. Coins are awarded by admin after each successful subscription purchase. The amount is configurable by admin
20. Maximum coins usable per transaction is set by admin (default: 10). Users cannot apply more than this limit in a single redemption
21. Coin usage is optional and consent-based — seller must ask the user, and user must confirm before coins are applied
22. When coins are used, the seller compensates the user ₹1 per coin off the final bill. Admin reimburses the seller for this amount during the weekly manual settlement. Both commission owed to admin and coin compensation owed to seller are tracked and displayed separately in settlement screens
23. Coin balance is per user wallet, visible in the app at all times, and carries forward across book renewals


# CouponAPI — Tech Stack Plan

> Derived from `ProjectBrief.md`. Aligned with the `nodejs-express-enterprise` skill.  
> **Updated:** User feedback applied (MSG91, 24h access token, simplified logging, no CI/CD/testing for MVP).

---

## Core Framework

| Concern | Choice | Reason |
|---|---|---|
| Runtime | **Node.js 20 LTS** | Matches skill baseline |
| Language | **TypeScript** (strict) | Type safety for complex business rules |
| Framework | **Express.js** | Established, skill-compatible |
| Architecture | **Controller → Service → Repository** | Clean separation, testable services |

---

## Database

| Layer | Choice | Reason |
|---|---|---|
| Primary DB | **PostgreSQL 16** | Relational data with City → Area → Seller → Coupon hierarchy; complex joins for settlement maths |
| ORM | **Prisma** | Type-safe queries, auto-generated types, migration tooling |
| Caching | **Redis 7** | OTP storage (TTL), refresh token blacklist, session data, rate-limit state |

### Why PostgreSQL over MongoDB?
The data is **highly relational**:
- Cities contain Areas
- Sellers belong to a City + Area
- Coupons belong to Sellers
- Users have Subscriptions → CouponBooks → Redemptions
- Settlements reference Redemptions

ACID guarantees are essential for wallet coin deductions and redemption recording.

---

## Authentication

| Concern | Choice |
|---|---|
| Customer/Seller login | **Phone + OTP** (via SMS provider) |
| Admin login | **Email + Password** (bcryptjs) |
| Session | **JWT** (access token **24h** + refresh token 7d, stored in Redis) |
| OTP storage | Redis with 5-min TTL |
| SMS Provider | **MSG91** (India-focused, cost-effective) |

---

## Payments

| Concern | Choice |
|---|---|
| Subscription payment | **Razorpay** (UPI, card, wallet) — explicitly required by brief |
| Webhook verification | `razorpay` npm SDK + HMAC signature verification middleware |

---

## Push Notifications

| Concern | Choice |
|---|---|
| Provider | **OneSignal** |
| SDK | `onesignal-node` (or official REST API) |
| Scheduling | **BullMQ** (Redis-backed) for scheduled/recurring jobs (e.g. 7-day expiry reminders) |

### Why OneSignal over FCM?
- **Easier Setup:** OneSignal abstracts away complex FCM/APNs credential management.
- **Rich Dashboard:** Superior admin dashboard for testing and analyzing push campaigns.
- **Segments/Tags:** Much easier to segment users (e.g., "users in Surat with expired subscriptions") directly via API tags without maintaining complex topics manually.

### Notification Triggers (from brief)
- 7-day expiry reminder
- 2-day expiry reminder
- Redemption confirmation
- Renewal success
- Coin credited alert
- Daily motivation push
- New coupon added alert

---

## QR Code

| Concern | Choice |
|---|---|
| User Profile QR generation | `qrcode` npm package |
| QR scanning (Seller app) | Handled by Flutter mobile app — API just validates the scanned data |
| Security | JWT-signed payload in QR, short-lived (e.g. 5-min TTL), refreshed by polling |

---

## Background Jobs

| Job | Trigger |
|---|---|
| Expiry reminders (7d, 2d) | BullMQ repeatable job — runs daily |
| Daily motivation push | BullMQ repeatable job — runs daily |
| Coin settlement tracking | On every redemption event |
| CSV export (admin) | On-demand async job via BullMQ |
| PDF settlement report | On-demand async job via BullMQ |

**Stack:** `bullmq` + Redis

---

## File / Report Generation

| Need | Choice |
|---|---|
| CSV export (users, settlements) | `csv-writer` or `papaparse` |
| PDF export (settlement reports) | `pdfkit` or `puppeteer` (lightweight: `pdfkit`) |

---

## API Documentation

| Concern | Choice |
|---|---|
| Docs | **Swagger UI** (`swagger-ui-express` + `zod-to-openapi`) |
| Route | `/api/docs` — dev + staging only |

---

## Security Middleware Stack

All from skill baseline:
- `helmet` — HTTP headers
- `cors` — CORS whitelist per environment
- `express-rate-limit` — global + stricter on `/api/auth/`
- `hpp` — HTTP parameter pollution
- `zod` — request body/query/param validation on every route

---

## Logging (MVP — Simple)

| Concern | Choice |
|---|---|
| Logger | `winston` + `morgan` |
| Log format | JSON (production), colorized (dev) |

> Metrics, Prometheus, and Sentry will be added post-MVP.

---

## Deployment & Infrastructure (MVP)

| Concern | Choice |
|---|---|
| Containerization | **Docker** (multi-stage build) |
| Compose (local dev) | `docker-compose.yml` (app + postgres + redis) |
| Hosting (recommended) | **Railway** or **Render** or a VPS (DigitalOcean) |

> PM2 and CI/CD (GitHub Actions) will be added after MVP.

---

## Folder Structure — Current vs Recommended

### ✅ Current Structure (Flat Layers)
Your project already has this set up:
```
src/
├── config/          # env.ts, db.ts, logger.ts ✅
├── controllers/     # (empty) ✅
├── services/        # (empty) ✅
├── repositories/    # (empty) ✅
├── models/          # (empty) ✅
├── middlewares/     # auth.ts, errorHandler.ts, security.ts, validate.ts ✅
├── routes/          # index.ts ✅
├── utils/           # AppError.ts, response.ts ✅
├── types/           # (empty) ✅
├── jobs/            # (empty) ✅
├── events/          # (empty) ✅
├── validators/      # (empty) ✅
├── app.ts
server.ts
```

### 🏗️ Recommended: Domain-Grouped (Best Practice)
For a project of this scale (3 user types, 11+ feature domains), grouping by feature rather than layer is far more maintainable:
```
src/
├── config/                   # env.ts, db.ts, logger.ts, redis.ts
├── shared/
│   ├── middlewares/          # auth, errorHandler, security, validate
│   ├── utils/                # AppError.ts, response.ts, jwt.ts, qrcode.ts
│   └── types/                # Shared TS interfaces
│
├── modules/
│   ├── auth/                 # routes, controller, service, validators
│   ├── users/                # routes, controller, service, repository, validators
│   ├── sellers/              # routes, controller, service, repository, validators
│   ├── coupons/              # routes, controller, service, repository, validators
│   ├── redemptions/          # routes, controller, service, repository, validators
│   ├── wallet/               # routes, controller, service, repository
│   ├── settlements/          # routes, controller, service, repository
│   ├── notifications/        # routes, controller, service (OneSignal)
│   ├── payments/             # routes, controller, service (Razorpay), webhook
│   ├── analytics/            # routes, controller, service
│   └── admin/                # routes, controller, service (city/area/settings)
│
├── jobs/                     # BullMQ workers (expiryReminder, dailyPush)
├── events/                   # Event emitters (optional)
├── app.ts
server.ts
```

### 📌 Recommendation
> **Switch to domain-grouped structure** before building any modules. The current flat-layer structure is fine for a basic CRUD app but will become hard to navigate as 11 domains grow independently. Each module folder will contain its own `*.routes.ts`, `*.controller.ts`, `*.service.ts`, `*.repository.ts`, and `*.validator.ts`.

---

## What's NOT in Scope for MVP
- **No peer-to-peer payments** — user pays seller directly; platform only handles ₹1000 via Razorpay
- **No in-app UPI QR generation** — seller's Flutter app handles that
- **No multi-currency** — INR only
- **No real-time WebSockets** — QR refresh via polling is sufficient
- **No CI/CD, PM2, Sentry, Prometheus** — post-MVP
- **No automated tests** — post-MVP

---

## Final Summary Table

| Category | Technology | MVP? |
|---|---|---|
| Runtime | Node.js 20 LTS + TypeScript | ✅ |
| Framework | Express.js | ✅ |
| ORM & DB | Prisma + PostgreSQL 16 | ✅ |
| Cache / Queue | Redis 7 + BullMQ | ✅ |
| Auth | JWT (24h access / 7d refresh) + OTP via **MSG91** | ✅ |
| Payments | **Razorpay** | ✅ |
| Push Notifications | **OneSignal** | ✅ |
| QR Code | `qrcode` npm package | ✅ |
| Validation | Zod | ✅ |
| API Docs | Swagger UI | ✅ |
| Logging | Winston + Morgan (simple) | ✅ |
| Containerization | Docker + Docker Compose | ✅ |
| Metrics / Tracing | Prometheus + Sentry | ❌ Post-MVP |
| CI/CD | GitHub Actions | ❌ Post-MVP |
| Process Manager | PM2 | ❌ Post-MVP |
| Testing | Jest + Supertest | ❌ Post-MVP |
