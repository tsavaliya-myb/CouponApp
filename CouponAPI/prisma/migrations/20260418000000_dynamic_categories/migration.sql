-- CreateTable: categories
CREATE TABLE "categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "iconName" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "categories_name_key" ON "categories"("name");
CREATE UNIQUE INDEX "categories_slug_key" ON "categories"("slug");

-- Seed default categories (matching the old SellerCategory enum values)
INSERT INTO "categories" ("id", "name", "slug", "updatedAt") VALUES
    (gen_random_uuid(), 'Food',    'food',    NOW()),
    (gen_random_uuid(), 'Salon',   'salon',   NOW()),
    (gen_random_uuid(), 'Theater', 'theater', NOW()),
    (gen_random_uuid(), 'Spa',     'spa',     NOW()),
    (gen_random_uuid(), 'Cafe',    'cafe',    NOW()),
    (gen_random_uuid(), 'Other',   'other',   NOW());

-- AlterTable: add nullable categoryId to sellers
ALTER TABLE "sellers" ADD COLUMN "categoryId" TEXT;

-- Migrate existing seller category enum values → new category IDs
UPDATE "sellers" s
SET "categoryId" = c.id
FROM "categories" c
WHERE LOWER(c.slug) = LOWER(s.category::text);

-- Fallback: any unmatched sellers → 'other'
UPDATE "sellers"
SET "categoryId" = (SELECT id FROM "categories" WHERE slug = 'other')
WHERE "categoryId" IS NULL;

-- Make categoryId NOT NULL
ALTER TABLE "sellers" ALTER COLUMN "categoryId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "sellers" ADD CONSTRAINT "sellers_categoryId_fkey"
    FOREIGN KEY ("categoryId") REFERENCES "categories"("id")
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Drop old category column
ALTER TABLE "sellers" DROP COLUMN "category";

-- Drop old enum type
DROP TYPE IF EXISTS "SellerCategory";
