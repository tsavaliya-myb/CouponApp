-- AlterTable
ALTER TABLE "categories" ADD COLUMN     "color" TEXT,
ADD COLUMN     "subtitle" TEXT;

-- AlterTable
ALTER TABLE "subscriptions" ADD COLUMN     "isAutopayEnabled" BOOLEAN NOT NULL DEFAULT true;
