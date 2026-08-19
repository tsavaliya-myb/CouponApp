import { Prisma } from '@prisma/client';
import { prisma } from '../../config/db';
import { logger } from '../../config/logger';

/**
 * CouponBackfillService
 *
 * UserCoupons are normally instantiated once, at subscription fulfilment
 * (payments.service.ts -> fulfillSubscription). Any base coupon created or
 * activated *after* a user's book was issued would therefore never appear in
 * that book — the coupon exists as a master `coupons` row, but the user's
 * `user_coupons` copy is missing, so GET /coupons (and every screen built on
 * it) shows nothing for that seller.
 *
 * This service closes that gap: it inserts the missing `user_coupons` rows
 * into every currently-live coupon book belonging to a user in the same city
 * as the coupon's seller.
 *
 * Idempotent — relies on the unique index
 * `user_coupons_couponBookId_couponId_key` + ON CONFLICT DO NOTHING, so it can
 * be run repeatedly and concurrently without creating duplicates.
 */
export class CouponBackfillService {
  /**
   * Insert the given base coupons into all live coupon books of their city.
   *
   * Only coupons that are `isBaseCoupon = true` AND `status = 'ACTIVE'` are
   * considered — the caller may pass ids without pre-filtering.
   *
   * @param couponIds Coupons to backfill. Omit to backfill every ACTIVE base
   *                  coupon on the platform (used by the repair script).
   * @returns Number of `user_coupons` rows actually inserted.
   */
  static async backfillBaseCoupons(couponIds?: string[]): Promise<number> {
    if (couponIds && couponIds.length === 0) return 0;

    const couponFilter = couponIds
      ? Prisma.sql`AND c.id IN (${Prisma.join(couponIds)})`
      : Prisma.empty;

    try {
      const inserted = await prisma.$executeRaw`
        INSERT INTO "user_coupons" (
          "id", "couponBookId", "couponId", "usesRemaining",
          "status", "createdAt", "updatedAt"
        )
        SELECT
          gen_random_uuid(),
          cb."id",
          c."id",
          c."maxUsesPerBook",
          'ACTIVE'::"UserCouponStatus",
          now(),
          now()
        FROM "coupons" c
        JOIN "sellers"      s  ON s."id"      = c."sellerId"
        JOIN "users"        u  ON u."cityId"  = s."cityId"
        JOIN "coupon_books" cb ON cb."userId" = u."id"
        WHERE c."isBaseCoupon" = true
          AND c."status" = 'ACTIVE'::"CouponStatus"
          AND cb."validFrom"  <= now()
          AND cb."validUntil" >= now()
          ${couponFilter}
        ON CONFLICT ("couponBookId", "couponId") DO NOTHING
      `;

      if (inserted > 0) {
        logger.info(
          `couponBackfill: inserted ${inserted} user_coupons ` +
          `(coupons: ${couponIds ? couponIds.join(',') : 'ALL ACTIVE BASE'})`,
        );
      }

      return inserted;
    } catch (err) {
      logger.error('couponBackfill failed', err);
      throw err;
    }
  }

  /**
   * Fire-and-forget variant for request paths where a backfill failure must
   * not fail the admin's write (the coupon itself is already persisted).
   */
  static backfillInBackground(couponIds: string[]): void {
    this.backfillBaseCoupons(couponIds).catch(() => {
      logger.error('couponBackfill: background backfill failed', { couponIds });
    });
  }
}
