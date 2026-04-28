-- CreateEnum
CREATE TYPE "BannerAdStatus" AS ENUM ('PENDING_REVIEW', 'ACTIVE', 'PAUSED', 'REJECTED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "BannerAdSlot" AS ENUM ('HOME_TOP', 'HOME_MID', 'CATEGORY_TOP');

-- CreateTable
CREATE TABLE "banner_ads" (
    "id" TEXT NOT NULL,
    "sellerId" TEXT NOT NULL,
    "cityId" TEXT,
    "title" TEXT NOT NULL,
    "imageUrl" TEXT,
    "videoUrl" TEXT,
    "actionUrl" TEXT,
    "slot" "BannerAdSlot" NOT NULL DEFAULT 'HOME_TOP',
    "status" "BannerAdStatus" NOT NULL DEFAULT 'PENDING_REVIEW',
    "startsAt" TIMESTAMP(3),
    "endsAt" TIMESTAMP(3),
    "adminNote" TEXT,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "clicks" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "banner_ads_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "banner_ads_sellerId_idx" ON "banner_ads"("sellerId");

-- CreateIndex
CREATE INDEX "banner_ads_status_startsAt_endsAt_idx" ON "banner_ads"("status", "startsAt", "endsAt");

-- AddForeignKey
ALTER TABLE "banner_ads" ADD CONSTRAINT "banner_ads_sellerId_fkey" FOREIGN KEY ("sellerId") REFERENCES "sellers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "banner_ads" ADD CONSTRAINT "banner_ads_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "cities"("id") ON DELETE SET NULL ON UPDATE CASCADE;
