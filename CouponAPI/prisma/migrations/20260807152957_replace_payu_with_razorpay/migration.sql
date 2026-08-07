-- Cleanup: stale PayU MANDATE attempts that never received a PayU response
-- (payuPaymentId and authPayUID both null) cannot carry a real razorpayOrderId
-- and predate any live PayU integration in this environment — see
-- RAZORPAY_MIGRATION_PLAN.md §9. Scoped narrowly so it cannot touch a
-- completed/attempted transaction.
DELETE FROM "payment_attempts"
WHERE "payuPaymentId" IS NULL AND "authPayUID" IS NULL;

-- DropIndex
DROP INDEX "payment_attempts_txnid_key";

-- AlterTable
ALTER TABLE "payment_attempts" DROP COLUMN "authPayUID",
DROP COLUMN "errorMessage",
DROP COLUMN "payuPaymentId",
DROP COLUMN "txnid",
ADD COLUMN     "errorDescription" TEXT,
ADD COLUMN     "razorpayOrderId" TEXT NOT NULL,
ADD COLUMN     "razorpayPaymentId" TEXT,
ADD COLUMN     "razorpayTokenId" TEXT;

-- AlterTable
ALTER TABLE "subscriptions" DROP COLUMN "authPayUID",
DROP COLUMN "mandateEndDate",
DROP COLUMN "mandateStartDate",
DROP COLUMN "payuPaymentId",
ADD COLUMN     "mandateExpiresAt" TIMESTAMP(3),
ADD COLUMN     "mandateMaxAmount" INTEGER,
ADD COLUMN     "razorpayPaymentId" TEXT,
ADD COLUMN     "razorpayTokenId" TEXT;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "razorpayCustomerId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "payment_attempts_razorpayOrderId_key" ON "payment_attempts"("razorpayOrderId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_attempts_razorpayPaymentId_key" ON "payment_attempts"("razorpayPaymentId");

-- CreateIndex
CREATE INDEX "payment_attempts_status_kind_idx" ON "payment_attempts"("status", "kind");

-- CreateIndex
CREATE INDEX "subscriptions_status_isAutopayEnabled_endDate_idx" ON "subscriptions"("status", "isAutopayEnabled", "endDate");

-- CreateIndex
CREATE UNIQUE INDEX "users_razorpayCustomerId_key" ON "users"("razorpayCustomerId");

