-- Migration: redesign_banner_ads_admin_multicity
-- Drops the old single-city, slot-based, seller-submitted banner ad design
-- and replaces it with admin-created, multi-city, slider-only ads.

-- Step 1: Drop FKs that will be removed or changed
ALTER TABLE "banner_ads" DROP CONSTRAINT IF EXISTS "banner_ads_cityId_fkey";
ALTER TABLE "banner_ads" DROP CONSTRAINT IF EXISTS "banner_ads_sellerId_fkey";

-- Step 2: Remove columns that no longer exist
ALTER TABLE "banner_ads"
  DROP COLUMN IF EXISTS "cityId",
  DROP COLUMN IF EXISTS "slot",
  DROP COLUMN IF EXISTS "adminNote";

-- Step 3: Make sellerId nullable
ALTER TABLE "banner_ads" ALTER COLUMN "sellerId" DROP NOT NULL;

-- Step 4: Fill in nulls before making dates required
UPDATE "banner_ads" SET "startsAt" = NOW() WHERE "startsAt" IS NULL;
UPDATE "banner_ads" SET "endsAt"   = NOW() + INTERVAL '30 days' WHERE "endsAt" IS NULL;
ALTER TABLE "banner_ads" ALTER COLUMN "startsAt" SET NOT NULL;
ALTER TABLE "banner_ads" ALTER COLUMN "endsAt"   SET NOT NULL;

-- Step 5: Fix existing rows to only have valid new enum values
UPDATE "banner_ads" SET "status" = 'ACTIVE' WHERE "status" IN ('PENDING_REVIEW', 'REJECTED');

-- Step 6: Drop DEFAULT before altering enum type (PostgreSQL requirement)
ALTER TABLE "banner_ads" ALTER COLUMN "status" DROP DEFAULT;

-- Step 7: Create the new leaner enum
CREATE TYPE "BannerAdStatus_new" AS ENUM ('ACTIVE', 'PAUSED', 'COMPLETED');

-- Step 8: Drop old slot enum
DROP TYPE IF EXISTS "BannerAdSlot";

-- Step 9: Cast column to new enum (default is already dropped so this works)
ALTER TABLE "banner_ads"
  ALTER COLUMN "status" TYPE "BannerAdStatus_new"
  USING "status"::text::"BannerAdStatus_new";

-- Step 10: Swap enum type name
DROP TYPE "BannerAdStatus";
ALTER TYPE "BannerAdStatus_new" RENAME TO "BannerAdStatus";

-- Step 11: Restore the default using the new enum
ALTER TABLE "banner_ads" ALTER COLUMN "status" SET DEFAULT 'ACTIVE'::"BannerAdStatus";

-- Step 12: Re-add FK for sellerId (now nullable → SET NULL on delete)
ALTER TABLE "banner_ads"
  ADD CONSTRAINT "banner_ads_sellerId_fkey"
  FOREIGN KEY ("sellerId") REFERENCES "sellers"("id")
  ON DELETE SET NULL ON UPDATE CASCADE;

-- Step 13: Create many-to-many join table for cities
CREATE TABLE "banner_ad_cities" (
  "id"         TEXT NOT NULL,
  "bannerAdId" TEXT NOT NULL,
  "cityId"     TEXT NOT NULL,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT "banner_ad_cities_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "banner_ad_cities_bannerAdId_cityId_key"
  ON "banner_ad_cities"("bannerAdId", "cityId");

ALTER TABLE "banner_ad_cities"
  ADD CONSTRAINT "banner_ad_cities_bannerAdId_fkey"
  FOREIGN KEY ("bannerAdId") REFERENCES "banner_ads"("id")
  ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "banner_ad_cities"
  ADD CONSTRAINT "banner_ad_cities_cityId_fkey"
  FOREIGN KEY ("cityId") REFERENCES "cities"("id")
  ON DELETE RESTRICT ON UPDATE CASCADE;
