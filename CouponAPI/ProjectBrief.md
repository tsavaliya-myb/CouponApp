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

### Login
- Register with phone number
- Verify phone with OTP

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