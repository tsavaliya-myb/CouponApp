-- CreateEnum
CREATE TYPE "InfluencerStatus" AS ENUM ('PENDING', 'ACTIVE', 'SUSPENDED', 'REJECTED');

-- CreateEnum
CREATE TYPE "InfluencerPlatform" AS ENUM ('INSTAGRAM', 'YOUTUBE', 'TWITTER', 'FACEBOOK', 'SNAPCHAT', 'TIKTOK', 'LINKEDIN');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('ENQUIRED', 'ACCEPTED', 'IN_PROGRESS', 'DELIVERED', 'CANCELLED');

-- AlterTable
ALTER TABLE "wallet_transactions" ADD COLUMN     "influencerBookingId" TEXT;

-- CreateTable
CREATE TABLE "influencer_niches" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "iconName" TEXT,
    "color" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "influencer_niches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "influencers" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "nicheId" TEXT NOT NULL,
    "cityId" TEXT NOT NULL,
    "email" TEXT,
    "bio" TEXT,
    "totalFollowers" INTEGER NOT NULL DEFAULT 0,
    "socialLinks" JSONB NOT NULL DEFAULT '{}',
    "platforms" "InfluencerPlatform"[],
    "profilePhotoUrl" TEXT,
    "coverPhotoUrl" TEXT,
    "engagementRate" DOUBLE PRECISION,
    "upiId" TEXT,
    "commissionPct" DOUBLE PRECISION NOT NULL DEFAULT 5,
    "status" "InfluencerStatus" NOT NULL DEFAULT 'PENDING',
    "onesignalPlayerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "influencers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "influencer_services" (
    "id" TEXT NOT NULL,
    "influencerId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DOUBLE PRECISION NOT NULL,
    "discountedPrice" DOUBLE PRECISION,
    "deliveryDays" INTEGER NOT NULL DEFAULT 3,
    "isHighlighted" BOOLEAN NOT NULL DEFAULT false,
    "status" "CouponStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "influencer_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "influencer_service_bookings" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "influencerId" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "pricePaid" DOUBLE PRECISION NOT NULL,
    "coinsUsed" INTEGER NOT NULL DEFAULT 0,
    "commissionAmt" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "coinCompensationAmt" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "status" "BookingStatus" NOT NULL DEFAULT 'ENQUIRED',
    "userNote" TEXT,
    "deliveryNote" TEXT,
    "acceptedAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "influencer_service_bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "influencer_agreements" (
    "id" TEXT NOT NULL,
    "influencerId" TEXT NOT NULL,
    "leegalityDocumentId" TEXT,
    "status" "AgreementStatus" NOT NULL DEFAULT 'PENDING',
    "signUrl" TEXT,
    "virtualSignUrl" TEXT,
    "signedDocumentUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "influencer_agreements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "influencer_niches_name_key" ON "influencer_niches"("name");

-- CreateIndex
CREATE UNIQUE INDEX "influencer_niches_slug_key" ON "influencer_niches"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "influencers_phone_key" ON "influencers"("phone");

-- CreateIndex
CREATE INDEX "influencer_service_bookings_userId_idx" ON "influencer_service_bookings"("userId");

-- CreateIndex
CREATE INDEX "influencer_service_bookings_influencerId_idx" ON "influencer_service_bookings"("influencerId");

-- CreateIndex
CREATE INDEX "influencer_service_bookings_serviceId_idx" ON "influencer_service_bookings"("serviceId");

-- CreateIndex
CREATE INDEX "influencer_service_bookings_status_idx" ON "influencer_service_bookings"("status");

-- CreateIndex
CREATE UNIQUE INDEX "influencer_agreements_influencerId_key" ON "influencer_agreements"("influencerId");

-- CreateIndex
CREATE UNIQUE INDEX "influencer_agreements_leegalityDocumentId_key" ON "influencer_agreements"("leegalityDocumentId");

-- AddForeignKey
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_influencerBookingId_fkey" FOREIGN KEY ("influencerBookingId") REFERENCES "influencer_service_bookings"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencers" ADD CONSTRAINT "influencers_nicheId_fkey" FOREIGN KEY ("nicheId") REFERENCES "influencer_niches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencers" ADD CONSTRAINT "influencers_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencer_services" ADD CONSTRAINT "influencer_services_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "influencers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencer_service_bookings" ADD CONSTRAINT "influencer_service_bookings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencer_service_bookings" ADD CONSTRAINT "influencer_service_bookings_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "influencers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencer_service_bookings" ADD CONSTRAINT "influencer_service_bookings_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "influencer_services"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "influencer_agreements" ADD CONSTRAINT "influencer_agreements_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "influencers"("id") ON DELETE CASCADE ON UPDATE CASCADE;
