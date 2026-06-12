-- CreateEnum
CREATE TYPE "AgreementStatus" AS ENUM ('PENDING', 'INITIATED', 'AADHAAR_SIGNED', 'COMPLETED', 'FAILED');

-- CreateTable
CREATE TABLE "seller_agreements" (
    "id" TEXT NOT NULL,
    "sellerId" TEXT NOT NULL,
    "leegalityDocumentId" TEXT,
    "status" "AgreementStatus" NOT NULL DEFAULT 'PENDING',
    "signUrl" TEXT,
    "virtualSignUrl" TEXT,
    "signedDocumentUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "seller_agreements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "seller_agreements_sellerId_key" ON "seller_agreements"("sellerId");

-- CreateIndex
CREATE UNIQUE INDEX "seller_agreements_leegalityDocumentId_key" ON "seller_agreements"("leegalityDocumentId");

-- AddForeignKey
ALTER TABLE "seller_agreements" ADD CONSTRAINT "seller_agreements_sellerId_fkey" FOREIGN KEY ("sellerId") REFERENCES "sellers"("id") ON DELETE CASCADE ON UPDATE CASCADE;
