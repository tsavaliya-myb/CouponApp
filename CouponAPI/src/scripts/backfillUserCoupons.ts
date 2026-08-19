/**
 * One-off repair script — backfill missing UserCoupons.
 *
 * Base coupons created or activated after a user's coupon book was issued were
 * never copied into that book (fulfilment was the only writer of
 * `user_coupons`). Those users see "No active coupons from this seller" even
 * though the master coupon is ACTIVE. This script inserts every missing row
 * into all currently-live books.
 *
 * Safe to re-run: the insert is ON CONFLICT DO NOTHING against the
 * (couponBookId, couponId) unique index.
 *
 * Usage:
 *   npx ts-node src/scripts/backfillUserCoupons.ts          # apply
 *   npx ts-node src/scripts/backfillUserCoupons.ts --dry    # report only
 */
import { prisma } from '../config/db';
import { CouponBackfillService } from '../shared/services/couponBackfill.service';

type MissingRow = {
  couponId: string;
  businessName: string;
  cityName: string;
  missingBooks: number;
};

async function reportMissing(): Promise<MissingRow[]> {
  return prisma.$queryRaw<MissingRow[]>`
    SELECT
      c."id"            AS "couponId",
      s."businessName"  AS "businessName",
      ct."name"         AS "cityName",
      CAST(COUNT(*) AS INTEGER) AS "missingBooks"
    FROM "coupons" c
    JOIN "sellers"      s  ON s."id"      = c."sellerId"
    JOIN "cities"       ct ON ct."id"     = s."cityId"
    JOIN "users"        u  ON u."cityId"  = s."cityId"
    JOIN "coupon_books" cb ON cb."userId" = u."id"
    WHERE c."isBaseCoupon" = true
      AND c."status" = 'ACTIVE'::"CouponStatus"
      AND cb."validFrom"  <= now()
      AND cb."validUntil" >= now()
      AND NOT EXISTS (
        SELECT 1 FROM "user_coupons" uc
        WHERE uc."couponBookId" = cb."id" AND uc."couponId" = c."id"
      )
    GROUP BY c."id", s."businessName", ct."name"
    ORDER BY "missingBooks" DESC
  `;
}

async function main(): Promise<void> {
  const dryRun = process.argv.includes('--dry');

  const missing = await reportMissing();

  if (missing.length === 0) {
    console.log('✅ Nothing to backfill — every live book already holds all ACTIVE base coupons.');
    return;
  }

  const totalRows = missing.reduce((sum, r) => sum + r.missingBooks, 0);
  console.log(`Found ${totalRows} missing user_coupons across ${missing.length} coupon(s):\n`);
  for (const row of missing) {
    console.log(`  ${row.businessName} (${row.cityName})  coupon ${row.couponId}  → ${row.missingBooks} book(s)`);
  }

  if (dryRun) {
    console.log('\n--dry given — no rows written.');
    return;
  }

  const inserted = await CouponBackfillService.backfillBaseCoupons();
  console.log(`\n✅ Inserted ${inserted} user_coupons.`);

  const remaining = await reportMissing();
  if (remaining.length > 0) {
    console.warn(`⚠️  ${remaining.length} coupon(s) still missing rows — re-run or investigate.`);
  }
}

main()
  .catch((err) => {
    console.error('❌ backfillUserCoupons failed:', err);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
