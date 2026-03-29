# Parent-Child Seller & Outlet Architecture Plan

This plan outlines the approach to transform the current `Seller` model into a centralized `Seller` account that manages multiple `Outlets`. 

## 1. Goal

Current architecture strictly maps 1 Seller to 1 Physical Location (City, Area, Address, Lat/Long). 
This migration enables **Brand Accounts (Sellers)** to own **Multiple Branches (Outlets)**. A seller will be able to log in with a single phone number and manage coupons across all their branches.

---

## 2. Proposed Changes

### 2.1 Database Schema Restructure (`prisma/schema.prisma`)

**A. Modify the `Seller` Model (The Parent / Brand Element)**
* Remove location-specific fields: `cityId`, `areaId`, `address`, `latitude`, `longitude`, `operatingHours`.
* The `Seller` model becomes the parent entity responsible for authentication, financial details (`upiId`), commission defaults, and brand status.
* Added relation mapping to the new `Outlet` table.
* Settlements remain attached to the `Seller` (centralized billing for the brand).

**B. Create the `Outlet` Model (The Children / Location Elements)**
* Move location and operational fields to this new table.
* **Fields:** `id`, `sellerId`, `name` (e.g. "Domino's - MG Road"), `phone` (optional, for specific outlet queries), `cityId`, `areaId`, `address`, `latitude`, `longitude`, `operatingHours`.
* Link to `Seller` with `onDelete: Cascade` (if a seller goes away, so do their outlets).

**C. Update `Coupon` Linkages**
* Keep `sellerId` in `Coupon` so the brand can manage their coupons.
* Introduce an implicit many-to-many relationship: `outlets Outlet[]` on the `Coupon` model. This allows the brand to choose if a 20% OFF coupon applies to *All Outlets* or just a *Specific Outlet*.

**D. Update `Redemption` Linkages**
* Change the relation in `Redemption` from `sellerId` to `outletId`. This ensures we keep track of *where* the redemption exactly took place (helpful for localized analytics).
* You can always fetch the `Seller` via the `Outlet` for settlement calculations.

---

### 2.2 API Migrations Required

**A. Seller Authentication (`src/modules/sellers`)**
* The login/OTP flow remains against the `Seller` model (which retains the unique `phone` number). No breaking changes to existing Auth.

**B. Admin & Seller Profile CRUD**
* `POST /admin/sellers` / `POST /sellers/profile`: Needs to be updated to accept a list of outlets or at least one `Outlet` object when registering a brand.
* Create new dedicated endpoints: 
    * `GET /sellers/outlets` 
    * `POST /sellers/outlets`
    * `PUT /sellers/outlets/:id`
    * `DELETE /sellers/outlets/:id`

**C. Coupon Management (`src/modules/coupons`)**
* When creating a coupon, the payload must accept an optional `outletIds` array. If empty, it defaults to all outlets for that seller.
* On the Customer Mobile App, when looking at a Seller Detail screen, we now need to retrieve and display the list of Outlets on a map.

**D. QR Scanner & Redemptions**
* The QR Scanner used by the merchant must identify which Outlet they are scanning from (or we provide the Merchant with a way to select their active Outlet in the app prior to scanning).
* The `redemptions.service.ts` needs to link the `OutletId` upon successful scan.

---

## 3. User Review Required

> [!WARNING]  
> This requires running a database migration which will inherently modify existing `Seller` rows. If this app is live in production, we need a custom data-migration script to securely transition "Old Sellers" to "Seller + 1 Default Outlet" automatically.

> [!CAUTION]  
> **Coupon Applicability:** Do you want a coupon to be tied automatically to ALL outlets by default, or do you strictly want the merchant to select which outlets a coupon applies to when they create it?

> [!NOTE]  
> **Mobile App Impact:** The frontend Mobile app will need to be updated to handle the new JSON structure. Instead of `seller.address`, it will now be `seller.outlets[0].address`.

## 4. Open Questions

1. **Merchant Scans:** When a merchant scans a user's QR code to redeem a coupon, how do we know *which* outlet they are scanning at? Should the Merchant App let the cashier select their current Outlet location after they login?
2. **Settlements:** Do you want weekly payouts (Settlements) calculated per *Seller (Brand)* or per *Outlet*? 

## 5. Verification Plan

1. Backup local DB.
2. Update `schema.prisma` and run `npx prisma migrate dev`.
3. Update `SellersService` to create a default `Outlet` when creating a new `Seller`.
4. Update TS Types and Validators to fix all broken references.
5. Create a test Seller with 3 Outlets.
6. Create a Coupon and link to 2 of the 3 Outlets, Verify the constraints via Swagger / Postman.
