# Caching Opportunities Report

Based on the [ProjectBrief.md](file:///e:/CouponApp/CouponAPI/ProjectBrief.md) and [implementation_plan.md](file:///e:/CouponApp/CouponAPI/implementation_plan.md), here are the key areas where we can utilize **Redis** caching to ensure fast API responses, reduce PostgreSQL load, and improve overall system performance.

---

## 1. High-Priority Caching (Low Change Frequency, High Read Volume)
These are ideal candidates for caching because the data rarely changes but is fetched frequently across all user sessions.

### A. App Settings (Phase 12)
- **Data:** `subscription_price`, `coins_per_subscription`, `max_coins_per_transaction`, etc.
- **Why:** Every redemption flow must check `max_coins_per_transaction` to validate coin usage, and subscription flows need the price. Reading this from PostgreSQL every time adds unnecessary latency.
- **Strategy:** Cache in Redis as a hash (`app:settings`). Invalidate and reload only when an admin updates them via `PATCH /api/v1/admin/settings`.

### B. Active Cities and Areas (Phase 2)
- **Data:** List of active cities and their associated areas.
- **Why:** Fetched constantly during user onboarding, seller registration, and global filtering.
- **Strategy:** Cache lists (`cities:all`, `city:{id}:areas`). Invalidate only when an admin adds or modifies a city/area.

### C. Base Coupons per City (Phase 6)
- **Data:** The standard set of base coupons assigned automatically to new users in a city.
- **Why:** Required instantly upon every successful subscription purchase webhook event to generate `UserCoupon` records.
- **Strategy:** Cache as `city:{id}:base_coupons`. Invalidate when the admin adds, edits, or deactivates a base coupon for that city.

---

## 2. Medium-Priority Caching (Dynamic but Query-Heavy)
These areas involve expensive database computations that can be avoided through smarter caching.

### A. Admin Dashboard & Analytics (Phase 10 & 13)
- **Data:** Top 10 sellers, most used coupons, revenue summaries, and active subscriber counts.
- **Why:** Aggregation queries (`GROUP BY`, `SUM`, `COUNT`) are resource-intensive on PostgreSQL, especially as the database grows.
- **Strategy:** Use BullMQ background jobs to compute these metrics periodically (e.g., every 15-30 minutes) and store the results in Redis. Serve the `GET /api/v1/admin/analytics/*` endpoints directly from Redis.

### B. Seller Proximity Search (Phase 4)
- **Data:** List of sellers in a city sorted by distance to the user (`GET /api/v1/sellers`).
- **Why:** Executing Haversine distance calculations directly on PostgreSQL for every user loading their Home screen is expensive.
- **Strategy:** Store seller coordinates using **Redis Geospatial Indexes** (`GEOADD`, `GEORADIUS`, or `GEOSEARCH`). When a user fetches sellers, query Redis for nearby seller IDs and then grab their cached profiles.

---

## 3. Real-Time & Transactional Caching (High Performance)
These areas require extremely low latency for real-world interactions.

### A. User Wallet Balance
- **Data:** A user's current coin balance.
- **Why:** Checked instantly during the redemption flow when the seller asks to apply coins.
- **Strategy:** Maintain the user's latest coin balance in a Redis key (`user:{id}:wallet_balance`). During a transaction, decrement it in Redis for speed, while simultaneously persisting the `WalletTransaction` and `Redemption` records in PostgreSQL within a transaction block.

### B. Seller Dashboard Counters (Phase 13)
- **Data:** Today's and This Week's redemption counts and commission approximations.
- **Why:** Sellers might frequently open their app to check daily earnings, causing repeated `COUNT` queries on the huge redemptions table.
- **Strategy:** Maintain simple counters in Redis (`seller:{id}:redemptions:today`). Increment these counters directly in Redis upon a successful redemption.

---

## 4. Operational Caching (Already Planned in Architecture)
These features heavily rely on Redis and are standard best practices included in the tech stack:

- **OTP Storage:** Storing generated OTPs (`otp:{phone}`) with a 5-minute TTL for fast verification without hitting the database.
- **Refresh Tokens:** Maintaining a blacklist/whitelist of active refresh tokens in Redis for immediate session revocation without checking PostgreSQL.
- **Rate Limiting:** IP and User-based rate limiting counts tracked in Redis to defend against abuse (`express-rate-limit` + Redis store).

---

## Conclusion
By aggressively caching **App Settings, Location Data, and Base Coupons**, we remove the most common read queries from the database. Offloading **Analytics and Distance Queries** to Redis Geospatial/Jobs saves heavy compute power. Utilizing Redis for **Wallet Balances and Counters** ensures the redemption loop (the core interaction between user and seller) remains instantly responsive.
