-- CreateEnum
CREATE TYPE "PaymentAttemptStatus" AS ENUM ('PENDING', 'SUCCESS', 'FAILED', 'CANCELLED');

-- AlterTable
ALTER TABLE "subscriptions" ADD COLUMN     "lastRenewalAt" TIMESTAMP(3),
ADD COLUMN     "mandateEndDate" TIMESTAMP(3),
ADD COLUMN     "mandateStartDate" TIMESTAMP(3),
ADD COLUMN     "preDebitNotifiedAt" TIMESTAMP(3),
ADD COLUMN     "renewalFailureCount" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "payment_attempts" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subscriptionId" TEXT,
    "txnid" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "kind" TEXT NOT NULL,
    "status" "PaymentAttemptStatus" NOT NULL DEFAULT 'PENDING',
    "payuPaymentId" TEXT,
    "authPayUID" TEXT,
    "errorCode" TEXT,
    "errorMessage" TEXT,
    "rawWebhook" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payment_attempts_txnid_key" ON "payment_attempts"("txnid");

-- CreateIndex
CREATE INDEX "payment_attempts_userId_idx" ON "payment_attempts"("userId");

-- AddForeignKey
ALTER TABLE "payment_attempts" ADD CONSTRAINT "payment_attempts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_attempts" ADD CONSTRAINT "payment_attempts_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE SET NULL ON UPDATE CASCADE;
