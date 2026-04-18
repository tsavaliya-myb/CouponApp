-- AlterEnum
ALTER TYPE "SellerStatus" ADD VALUE 'REJECTED';

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "coinBalance" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "seller_media" (
    "id" TEXT NOT NULL,
    "sellerId" TEXT NOT NULL,
    "logoUrl" TEXT,
    "photoUrl1" TEXT,
    "photoUrl2" TEXT,
    "videoUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "seller_media_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "seller_media_sellerId_key" ON "seller_media"("sellerId");

-- AddForeignKey
ALTER TABLE "seller_media" ADD CONSTRAINT "seller_media_sellerId_fkey" FOREIGN KEY ("sellerId") REFERENCES "sellers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
