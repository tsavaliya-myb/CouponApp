-- AlterTable
ALTER TABLE "areas" ADD COLUMN     "latitude" DOUBLE PRECISION,
ADD COLUMN     "longitude" DOUBLE PRECISION;

-- CreateTable
CREATE TABLE "area_distances" (
    "id" TEXT NOT NULL,
    "fromAreaId" TEXT NOT NULL,
    "toAreaId" TEXT NOT NULL,
    "distanceKm" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "area_distances_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "area_distances_fromAreaId_toAreaId_key" ON "area_distances"("fromAreaId", "toAreaId");

-- AddForeignKey
ALTER TABLE "area_distances" ADD CONSTRAINT "area_distances_fromAreaId_fkey" FOREIGN KEY ("fromAreaId") REFERENCES "areas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "area_distances" ADD CONSTRAINT "area_distances_toAreaId_fkey" FOREIGN KEY ("toAreaId") REFERENCES "areas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
