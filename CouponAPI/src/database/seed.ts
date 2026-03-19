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
  console.log('🌱 Seeding database...');

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

  const ahmedabad = await prisma.city.upsert({
    where: { name: 'Ahmedabad' },
    update: {},
    create: { name: 'Ahmedabad', status: 'COMING_SOON' },
  });

  const vadodara = await prisma.city.upsert({
    where: { name: 'Vadodara' },
    update: {},
    create: { name: 'Vadodara', status: 'COMING_SOON' },
  });

  console.log(`✅ Cities: ${surat.name} (ACTIVE), ${ahmedabad.name}, ${vadodara.name}`);

  // ── 3. Areas for Surat ─────────────────────────────────────────────────────
  const suratAreas = [
    'Adajan',
    'Katargam',
    'Varachha',
    'Sarthana',
  ];

  for (const areaName of suratAreas) {
    await prisma.area.upsert({
      where: { name_cityId: { name: areaName, cityId: surat.id } },
      update: {},
      create: { name: areaName, cityId: surat.id, isActive: true },
    });
  }
  console.log(`✅ Areas for Surat: ${suratAreas.length} areas seeded`);

  // ── 4. App Settings (default values) ──────────────────────────────────────
  const settings = [
    { key: 'subscription_price', value: '1000' },
    { key: 'book_validity_days', value: '45' },
    { key: 'coins_per_subscription', value: '50' },
    { key: 'max_coins_per_transaction', value: '10' },
    { key: 'expiry_reminder_7d_title', value: 'Your coupon book expires in 7 days!' },
    { key: 'expiry_reminder_7d_body', value: 'Renew now to keep enjoying exclusive discounts across Surat.' },
    { key: 'expiry_reminder_2d_title', value: 'Only 2 days left on your coupon book!' },
    { key: 'expiry_reminder_2d_body', value: 'Don\'t miss out — renew today and save more.' },
    { key: 'daily_motivation_title', value: 'Have you used your coupons today?' },
    { key: 'daily_motivation_body', value: 'Save big at top restaurants, salons, and more near you!' },
  ];

  for (const setting of settings) {
    await prisma.appSetting.upsert({
      where: { key: setting.key },
      update: {},
      create: setting,
    });
  }
  console.log(`✅ App settings: ${settings.length} defaults seeded`);

  console.log('\n🎉 Seed complete!');
  console.log('   Admin email:    admin@couponapp.in');
  console.log('   Admin password: Admin@123 (please change before production!)');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
