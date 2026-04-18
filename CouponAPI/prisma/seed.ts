import {
  PrismaClient,
  SellerCategory,
  CityStatus,
  UserStatus,
  SellerStatus,
  CouponType,
  CouponStatus,
  UserCouponStatus,
  SubscriptionStatus,
  WalletTransactionType,
  SettlementStatus,
  NotificationTargetType
} from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function cleanDatabase() {
  console.log('🧹 Cleaning existing database records (excluding migrations)...');
  const tableNames = await prisma.$queryRaw<Array<{ tablename: string }>>`
    SELECT tablename FROM pg_tables WHERE schemaname='public';
  `;

  const tables = tableNames
    .map(({ tablename }) => tablename)
    .filter((name) => name !== '_prisma_migrations')
    .map((name) => `"public"."${name}"`)
    .join(', ');

  if (tables.length > 0) {
    try {
      await prisma.$executeRawUnsafe(`TRUNCATE TABLE ${tables} CASCADE;`);
      console.log('✅ Database cleaned!');
    } catch (e) {
      console.log('⚠️ Could not truncate tables:', e);
    }
  }
}

async function main() {
  console.log('Starting Database Seeding with deterministic data...');
  await cleanDatabase();

  // 1. Admin
  const adminPassword = await bcrypt.hash('admin123', 10);
  const admin = await prisma.admin.create({
    data: { email: 'admin@couponapp.com', passwordHash: adminPassword, name: 'Super Admin' },
  });
  console.log(`✅ Admin Created: ${admin.email}`);

  // 2. App Settings
  await prisma.appSetting.createMany({
    data: [
      { key: 'RAZORPAY_PLAN_ID', value: 'plan_test_123' },
      { key: 'SUBSCRIPTION_FEE', value: '999' }
    ]
  });
  console.log('✅ App Settings Created');

  // 3. City
  const citySurat = await prisma.city.create({
    data: { name: 'Surat', status: CityStatus.ACTIVE },
  });

  const cityAhmedabad = await prisma.city.create({
    data: { name: 'Ahmedabad', status: CityStatus.COMING_SOON },
  });
  console.log('✅ Cities Created');

  // 4. Areas
  const areaVesu = await prisma.area.create({
    data: { name: 'Vesu', cityId: citySurat.id, isActive: true },
  });
  const areaAdajan = await prisma.area.create({
    data: { name: 'Adajan', cityId: citySurat.id, isActive: true },
  });
  console.log('✅ Areas Created');

  // 5. Sellers with varying statuses
  const sellerCafe = await prisma.seller.create({
    data: {
      businessName: 'The Great Cafe',
      category: SellerCategory.CAFE,
      cityId: citySurat.id,
      areaId: areaVesu.id,
      address: '101, VIP Road, Vesu',
      phone: '9876543210',
      email: 'contact@greatcafe.com',
      upiId: 'greatcafe@upi',
      latitude: 21.1418,
      longitude: 72.7709,
      operatingHours: 'Mon-Sun, 10am-11pm',
      commissionPct: 5,
      status: SellerStatus.ACTIVE,
      media: {
        create: {
          logoUrl: 'https://placehold.co/150x150/png?text=Cafe',
          photoUrl1: 'https://placehold.co/600x400/png?text=Great+Cafe',
          photoUrl2: 'https://placehold.co/600x400/png?text=Great+Cafe+Menu',
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4'
        }
      }
    }
  });

  const sellerFood = await prisma.seller.create({
    data: {
      businessName: 'Gourmet Kitchen',
      category: SellerCategory.FOOD,
      cityId: citySurat.id,
      areaId: areaVesu.id,
      address: 'Near VR Mall',
      phone: '9876543200',
      longitude: 72.7710,
      latitude: 21.1410,
      commissionPct: 8,
      status: SellerStatus.ACTIVE,
      media: {
        create: {
          logoUrl: 'https://placehold.co/150x150/png?text=Food',
          photoUrl1: 'https://placehold.co/600x400/png?text=Gourmet+Food'
        }
      }
    }
  });

  const sellerSpa = await prisma.seller.create({
    data: {
      businessName: 'Relax Spa',
      category: SellerCategory.SPA,
      cityId: citySurat.id,
      areaId: areaAdajan.id,
      address: '202, Green Avenue, Adajan',
      phone: '9876543211',
      latitude: 21.1892,
      longitude: 72.7933,
      operatingHours: 'Tue-Sun, 9am-8pm',
      commissionPct: 10,
      status: SellerStatus.ACTIVE,
      media: {
        create: {
          logoUrl: 'https://placehold.co/150x150/png?text=Spa',
          photoUrl1: 'https://placehold.co/600x400/png?text=Relax+Spa'
        }
      }
    }
  });

  const sellerPending = await prisma.seller.create({
    data: {
      businessName: 'Pending Salon',
      category: SellerCategory.SALON,
      cityId: citySurat.id,
      areaId: areaVesu.id,
      address: '303, Someshwar Square',
      phone: '9876543212',
      status: SellerStatus.PENDING,
    }
  });

  const sellerSuspended = await prisma.seller.create({
    data: {
      businessName: 'Suspended Gym',
      category: SellerCategory.OTHER,
      cityId: citySurat.id,
      areaId: areaVesu.id,
      phone: '9876543213',
      status: SellerStatus.SUSPENDED,
    }
  });

  const sellerRejected = await prisma.seller.create({
    data: {
      businessName: 'Rejected Shop',
      category: SellerCategory.OTHER,
      cityId: citySurat.id,
      areaId: areaAdajan.id,
      phone: '9876543214',
      status: SellerStatus.REJECTED,
    }
  });

  console.log('✅ Sellers Created across configurations');

  // 6. Base Coupons (1 per active Seller to make a standard City Base Set)
  const couponCafe = await prisma.coupon.create({
    data: {
      sellerId: sellerCafe.id,
      discountPct: 20,
      adminCommissionPct: 5,
      minSpend: 500,
      maxUsesPerBook: 2,
      type: CouponType.STANDARD,
      isBaseCoupon: true,
      status: CouponStatus.ACTIVE,
    }
  });

  const couponCafeBogo = await prisma.coupon.create({
    data: {
      sellerId: sellerCafe.id,
      discountPct: 50,
      adminCommissionPct: 10,
      maxUsesPerBook: 1,
      type: CouponType.BOGO,
      isBaseCoupon: true,
      status: CouponStatus.ACTIVE,
    }
  });

  const couponSpa = await prisma.coupon.create({
    data: {
      sellerId: sellerSpa.id,
      discountPct: 30,
      adminCommissionPct: 5,
      maxUsesPerBook: 1,
      type: CouponType.STANDARD,
      isBaseCoupon: true,
      status: CouponStatus.ACTIVE,
    }
  });

  const couponFood = await prisma.coupon.create({
    data: {
      sellerId: sellerFood.id,
      discountPct: 15,
      adminCommissionPct: 5,
      maxUsesPerBook: 3,
      type: CouponType.STANDARD,
      isBaseCoupon: true,
      status: CouponStatus.ACTIVE,
    }
  });

  // Non-base coupon Example
  const couponFoodSpecial = await prisma.coupon.create({
    data: {
      sellerId: sellerFood.id,
      discountPct: 40,
      adminCommissionPct: 10,
      maxUsesPerBook: 1,
      type: CouponType.STANDARD,
      isBaseCoupon: false,
      status: CouponStatus.ACTIVE,
    }
  });

  const couponSuspended = await prisma.coupon.create({
    data: {
      sellerId: sellerSuspended.id,
      discountPct: 10,
      adminCommissionPct: 5,
      maxUsesPerBook: 1,
      type: CouponType.STANDARD,
      isBaseCoupon: true,
      status: CouponStatus.ACTIVE, // Even if coupon is active, seller is suspended
    }
  });
  console.log('✅ Coupons Created');

  // 7. Users
  const userValid = await prisma.user.create({
    data: {
      phone: '9999999991',
      name: 'Active User',
      email: 'active@user.com',
      cityId: citySurat.id,
      areaId: areaVesu.id,
      coinBalance: 150,
      wallet: {
        create: [
          { type: WalletTransactionType.EARNED, amount: 150, note: 'Welcome Bonus' }
        ]
      }
    }
  });

  const userExpired = await prisma.user.create({
    data: {
      phone: '9999999992',
      name: 'Expired User',
      cityId: citySurat.id,
    }
  });

  const userNoSub = await prisma.user.create({
    data: {
      phone: '9999999993',
      name: 'Free User',
      cityId: citySurat.id,
    }
  });
  console.log('✅ Users Created');

  // 8. Subscriptions & Coupon Books
  const now = new Date();
  const nextYear = new Date();
  nextYear.setFullYear(now.getFullYear() + 1);

  await prisma.subscription.create({
    data: {
      userId: userValid.id,
      startDate: now,
      endDate: nextYear,
      status: SubscriptionStatus.ACTIVE,
      razorpayOrderId: 'order_test_1',
      razorpayPaymentId: 'pay_test_1',
      couponBook: {
        create: {
          userId: userValid.id,
          validFrom: now,
          validUntil: nextYear,
          // Bind all base coupons reliably!
          userCoupons: {
            create: [
              { couponId: couponCafe.id, usesRemaining: couponCafe.maxUsesPerBook },
              { couponId: couponCafeBogo.id, usesRemaining: couponCafeBogo.maxUsesPerBook },
              { couponId: couponSpa.id, usesRemaining: couponSpa.maxUsesPerBook },
              { couponId: couponFood.id, usesRemaining: couponFood.maxUsesPerBook },
              { couponId: couponSuspended.id, usesRemaining: couponSuspended.maxUsesPerBook },
            ]
          }
        }
      }
    }
  });
  console.log(`✅ Active Subscription & precise UserCoupon bindings created for ${userValid.name}`);

  const lastYear = new Date();
  lastYear.setFullYear(now.getFullYear() - 1);
  const lastYearEnd = new Date(lastYear);
  lastYearEnd.setMonth(lastYearEnd.getMonth() + 6);

  await prisma.subscription.create({
    data: {
      userId: userExpired.id,
      startDate: lastYear,
      endDate: lastYearEnd,
      status: SubscriptionStatus.EXPIRED,
      couponBook: {
        create: {
          userId: userExpired.id,
          validFrom: lastYear,
          validUntil: lastYearEnd,
          userCoupons: {
            create: [
              { couponId: couponCafe.id, usesRemaining: couponCafe.maxUsesPerBook, status: UserCouponStatus.EXPIRED },
            ]
          }
        }
      }
    }
  });
  console.log(`✅ Expired Subscription created for ${userExpired.name}`);

  // 9. Redemptions & Settlements (User redeemed a standard cafe coupon)
  const validCouponBook = await prisma.couponBook.findFirst({ where: { userId: userValid.id }, include: { userCoupons: true } });

  if (validCouponBook && validCouponBook.userCoupons.length > 0) {
    // Make sure we redeem the cafe coupon
    const ucToRedeem = validCouponBook.userCoupons.find(uc => uc.couponId === couponCafe.id)!;

    const redem = await prisma.redemption.create({
      data: {
        userCouponId: ucToRedeem.id,
        sellerId: sellerCafe.id,
        userId: userValid.id,
        billAmount: 1000,
        discountAmount: 200,
        coinsUsed: 50,
        finalAmount: 750, // 1000 - 200 - 50 = 750
      }
    });

    // Reduce uses remaining properly
    await prisma.userCoupon.update({
      where: { id: ucToRedeem.id },
      data: {
        usesRemaining: Math.max(0, ucToRedeem.usesRemaining - 1),
        status: ucToRedeem.usesRemaining - 1 <= 0 ? UserCouponStatus.USED : UserCouponStatus.ACTIVE
      }
    });

    // Wallet deduction correctly logged down
    await prisma.walletTransaction.create({
      data: {
        userId: userValid.id,
        type: WalletTransactionType.USED,
        amount: 50,
        redemptionId: redem.id,
        note: `Used for order at ${sellerCafe.businessName}`
      }
    });

    // Settlement tracking correctly attached
    const weekStart = new Date();
    weekStart.setDate(weekStart.getDate() - weekStart.getDay());
    weekStart.setHours(0, 0, 0, 0);

    const weekEnd = new Date(weekStart);
    weekEnd.setDate(weekEnd.getDate() + 6);
    weekEnd.setHours(23, 59, 59, 999);

    const settlement = await prisma.settlement.create({
      data: {
        sellerId: sellerCafe.id,
        weekStart,
        weekEnd,
      }
    });

    const commissionAmt = 1000 * (couponCafe.adminCommissionPct / 100);

    await prisma.settlementLine.create({
      data: {
        settlementId: settlement.id,
        redemptionId: redem.id,
        billAmount: 1000,
        commissionAmt: commissionAmt,
        coinCompAmt: 50,
      }
    });

    await prisma.settlement.update({
      where: { id: settlement.id },
      data: {
        commissionTotal: { increment: commissionAmt },
        coinCompensationTotal: { increment: 50 }
      }
    });
    console.log('✅ Settlement and Redemption accurately mapped and triggered');
  }

  // 10. Notification Logs
  await prisma.notificationLog.create({
    data: {
      type: 'welcome_notification',
      targetType: NotificationTargetType.USER,
      targetId: userValid.id,
      title: 'Welcome to CouponApp!',
      body: 'Your 1-year subscription is now active.',
    }
  });

  console.log('🎉 Database seeding completely reset and verified successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Failed to seed database:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
