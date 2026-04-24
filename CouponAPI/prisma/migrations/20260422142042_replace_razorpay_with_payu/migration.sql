/*
  Warnings:

  - You are about to drop the column `razorpayOrderId` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `razorpayPaymentId` on the `subscriptions` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "subscriptions_razorpayPaymentId_key";

-- AlterTable
ALTER TABLE "subscriptions" DROP COLUMN "razorpayOrderId",
DROP COLUMN "razorpayPaymentId",
ADD COLUMN     "authPayUID" TEXT,
ADD COLUMN     "payuPaymentId" TEXT;
