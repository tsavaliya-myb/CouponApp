/**
 * Database seed for CouponApp.
 * Populates: Admin user, Cities (Surat as ACTIVE), and Areas for Surat.
 *
 * Run with: npx ts-node src/database/seed.ts
 */

import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database with comprehensive test data...');

  // ── 1. Admin User ──────────────────────────────────────────────────────────
  const passwordHash = await bcrypt.hash('Admin@123', 12);
  const admin = await prisma.admin.upsert({
    where: { email: 'admin@couponapp.in' },
    update: {},
    create: {
      email: 'admin@couponapp.in',
      passwordHash,
      name: 'Platform Admin',
    },
  });
  console.log(`✅ Admin: ${admin.email}`);

  // ── 2. Cities ──────────────────────────────────────────────────────────────
  const surat = await prisma.city.upsert({
    where: { name: 'Surat' },
    update: { status: 'ACTIVE' },
    create: { name: 'Surat', status: 'ACTIVE' },
  });
  console.log(`✅ City: ${surat.name} (ACTIVE)`);

  // ── 3. Areas for Surat ─────────────────────────────────────────────────────
  const suratAreas = ['Adajan', 'Katargam', 'Varachha', 'Vesu'];
  const dbAreas = [];
  for (const areaName of suratAreas) {
    const area = await prisma.area.upsert({
      where: { name_cityId: { name: areaName, cityId: surat.id } },
      update: {},
      create: { name: areaName, cityId: surat.id, isActive: true },
    });
    dbAreas.push(area);
  }
  console.log(`✅ Areas for Surat seeded.`);

  // ── 4. App Settings ────────────────────────────────────────────────────────
  const settings = [
    { key: 'subscription_price', value: '1000' },
    { key: 'book_validity_days', value: '45' },
    { key: 'COINS_PER_SUBSCRIPTION', value: '50' },
    { key: 'MAX_COINS_PER_TRANSACTION', value: '10' },
  ];
  for (const setting of settings) {
    await prisma.appSetting.upsert({
      where: { key: setting.key },
      update: { value: setting.value },
      create: setting,
    });
  }
  console.log(`✅ App settings seeded.`);

  // ── 5. Categories ──────────────────────────────────────────────────────────
  const categoryDefs = [
    { name: 'Food',    slug: 'food'    },
    { name: 'Salon',   slug: 'salon'   },
    { name: 'Theater', slug: 'theater' },
    { name: 'Spa',     slug: 'spa'     },
    { name: 'Cafe',    slug: 'cafe'    },
    { name: 'Other',   slug: 'other'   },
  ];
  const dbCategories: Record<string, string> = {};
  for (const cat of categoryDefs) {
    const c = await (prisma as any).category.upsert({
      where: { slug: cat.slug },
      update: {},
      create: cat,
    });
    dbCategories[cat.slug] = c.id;
  }
  console.log('✅ Categories seeded.');

  // ── 6. Sellers ─────────────────────────────────────────────────────────────
  console.log('⏳ Seeding Sellers...');
  const srCafe = await (prisma as any).seller.upsert({
    where: { phone: '9876543210' },
    update: {},
    create: {
      businessName: 'SR Cafe',
      categoryId: dbCategories['cafe'],
      cityId: surat.id,
      areaId: dbAreas[0].id,
      phone: '9876543210',
      commissionPct: 5,
      status: 'ACTIVE',
      latitude: 21.1702,
      longitude: 72.8311,
    }
  });

  const fancySalon = await (prisma as any).seller.upsert({
    where: { phone: '9876543211' },
    update: {},
    create: {
      businessName: 'Fancy Salon & Spa',
      categoryId: dbCategories['salon'],
      cityId: surat.id,
      areaId: dbAreas[3].id,
      phone: '9876543211',
      commissionPct: 10,
      status: 'ACTIVE',
    }
  });

  const testTheater = await (prisma as any).seller.upsert({
    where: { phone: '9876543212' },
    update: {},
    create: {
      businessName: 'Grand Cinemas',
      categoryId: dbCategories['theater'],
      cityId: surat.id,
      areaId: dbAreas[2].id,
      phone: '9876543212',
      commissionPct: 8,
      status: 'ACTIVE',
    }
  });

  // ── 7. Coupons ─────────────────────────────────────────────────────────────
  console.log('⏳ Seeding Coupons...');
  const coupon1 = await prisma.coupon.create({
    data: {
      sellerId: srCafe.id,
      discountPct: 20,
      adminCommissionPct: 5,
      minSpend: 200,
      maxUsesPerBook: 2,
      type: 'STANDARD',
      isBaseCoupon: true,
    }
  });

  const coupon2 = await prisma.coupon.create({
    data: {
      sellerId: fancySalon.id,
      discountPct: 50,
      adminCommissionPct: 10,
      minSpend: 500,
      maxUsesPerBook: 1,
      type: 'BOGO', // Suppose they offer 50% max representing BOGO
      isBaseCoupon: true,
    }
  });

  const coupon3 = await prisma.coupon.create({
    data: {
      sellerId: testTheater.id,
      discountPct: 15,
      adminCommissionPct: 8,
      maxUsesPerBook: 3,
      type: 'STANDARD',
      isBaseCoupon: true,
    }
  });

  // ── 7. Users ───────────────────────────────────────────────────────────────
  console.log('⏳ Seeding Users & Subscriptions...');
  const userA = await prisma.user.upsert({
    where: { phone: '1111111111' },
    update: {},
    create: {
      phone: '1111111111',
      name: 'John Doe',
      cityId: surat.id,
      areaId: dbAreas[0].id,
      coinBalance: 50, // They get coins from sub
    }
  });

  const userB = await prisma.user.upsert({
    where: { phone: '2222222222' },
    update: {},
    create: {
      phone: '2222222222',
      name: 'Jane Smith',
      cityId: surat.id,
      coinBalance: 0, 
    }
  });

  // ── 8. Subscriptions & Coupon Books ─────────────────────────────────────────
  const now = new Date();
  const nextMonth = new Date();
  nextMonth.setDate(now.getDate() + 45);

  const subA = await prisma.subscription.upsert({
    where: { userId: userA.id },
    update: {},
    create: {
      userId: userA.id,
      startDate: now,
      endDate: nextMonth,
      status: 'ACTIVE',
      razorpayOrderId: 'order_TEST123',
      razorpayPaymentId: 'pay_TEST123',
    }
  });

  const bookA = await prisma.couponBook.upsert({
    where: { subscriptionId: subA.id },
    update: {},
    create: {
      subscriptionId: subA.id,
      userId: userA.id,
      validFrom: now,
      validUntil: nextMonth,
    }
  });

  // Generate User Coupons for Book A
  const userCoupons = await Promise.all([
    prisma.userCoupon.create({ data: { couponBookId: bookA.id, couponId: coupon1.id, usesRemaining: coupon1.maxUsesPerBook } }),
    prisma.userCoupon.create({ data: { couponBookId: bookA.id, couponId: coupon2.id, usesRemaining: coupon2.maxUsesPerBook } }),
    prisma.userCoupon.create({ data: { couponBookId: bookA.id, couponId: coupon3.id, usesRemaining: coupon3.maxUsesPerBook } }),
  ]);

  // ── 9. Wallet Transactions ──────────────────────────────────────────────────
  await prisma.walletTransaction.create({
    data: {
      userId: userA.id,
      type: 'EARNED',
      amount: 50,
      note: 'Subscription Bonus',
    }
  });

  // ── 10. Redemptions & Settlements ───────────────────────────────────────────
  console.log('⏳ Seeding Redemptions...');
  const redemptionAmount = 1000;
  const discountAmount = 200; // 20% of 1000
  const coinsUsed = 10;
  
  // Redeem a coupon
  const redemption = await prisma.redemption.create({
    data: {
      userCouponId: userCoupons[0].id,
      sellerId: srCafe.id,
      userId: userA.id,
      billAmount: redemptionAmount,
      discountAmount,
      coinsUsed,
      finalAmount: redemptionAmount - discountAmount - coinsUsed,
    }
  });

  await prisma.userCoupon.update({
    where: { id: userCoupons[0].id },
    data: { usesRemaining: { decrement: 1 } },
  });

  // Deduct coins used from wallet
  await prisma.walletTransaction.create({
    data: {
      userId: userA.id,
      type: 'USED',
      amount: coinsUsed,
      redemptionId: redemption.id,
      note: `Used at ${srCafe.businessName}`,
    }
  });
  
  await prisma.user.update({
    where: { id: userA.id },
    data: { coinBalance: { decrement: coinsUsed } }
  });

  // Weekly Settlement mock
  const settlement = await prisma.settlement.create({
    data: {
      sellerId: srCafe.id,
      weekStart: new Date(now.getFullYear(), now.getMonth(), now.getDate() - now.getDay() + 1), // Monday
      weekEnd: new Date(now.getFullYear(), now.getMonth(), now.getDate() - now.getDay() + 7),
      commissionTotal: (redemptionAmount * 5) / 100, // 5% base commission
      coinCompensationTotal: coinsUsed,
    }
  });

  await prisma.settlementLine.create({
    data: {
      settlementId: settlement.id,
      redemptionId: redemption.id,
      billAmount: redemptionAmount,
      commissionAmt: (redemptionAmount * 5) / 100,
      coinCompAmt: coinsUsed,
    }
  });

  // ── 11. Notifications ───────────────────────────────────────────────────────
  await prisma.notificationLog.create({
    data: {
      type: 'seed_welcome',
      targetType: 'GLOBAL',
      title: 'Welcome to CouponApp!',
      body: 'Start enjoying exclusive deals in Surat today.',
    }
  });

  console.log('\n🎉 Comprehensive Seed complete! Generated:');
  console.log('   - 1 Admin');
  console.log('   - Cities & Areas');
  console.log('   - 3 Active Sellers across categories');
  console.log('   - 3 Base Coupons');
  console.log('   - 2 Users (1 with Active Subscription & CouponBook)');
  console.log('   - 1 Wallet EARNED Transaction, 1 USED Transaction');
  console.log('   - 1 Valid Redemption & Weekly Settlement Record');
  console.log('\n   Admin email:    admin@couponapp.in');
  console.log('   Admin password: Admin@123\n');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
