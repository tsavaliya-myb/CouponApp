import { PrismaClient, CityStatus, SellerStatus } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function cleanDatabase() {
  console.log('🧹 Cleaning database...');
  const tableNames = await prisma.$queryRaw<Array<{ tablename: string }>>`
    SELECT tablename FROM pg_tables WHERE schemaname='public';
  `;

  const tables = tableNames
    .map(({ tablename }) => tablename)
    .filter((name) => name !== '_prisma_migrations')
    .map((name) => `"public"."${name}"`)
    .join(', ');

  if (tables.length > 0) {
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE ${tables} CASCADE;`);
  }
  console.log('✅ Database cleaned');
}

async function main() {
  console.log('🌱 Seeding database...');
  await cleanDatabase();

  // 1. Admin
  const passwordHash = await bcrypt.hash('Admin@123', 12);
  const admin = await prisma.admin.create({
    data: { email: 'admin@couponapp.in', passwordHash, name: 'Platform Admin' },
  });
  console.log(`✅ Admin: ${admin.email}`);

  // 2. App Settings
  const settings = [
    { key: 'subscription_price',      value: '1000' },
    { key: 'book_validity_days',       value: '45'   },
    { key: 'COINS_PER_SUBSCRIPTION',   value: '50'   },
    { key: 'MAX_COINS_PER_TRANSACTION', value: '10'  },
  ];
  for (const s of settings) {
    await prisma.appSetting.create({ data: s });
  }
  console.log('✅ App Settings');

  // 3. Cities
  const surat = await prisma.city.create({
    data: { name: 'Surat', status: CityStatus.ACTIVE },
  });
  await prisma.city.create({
    data: { name: 'Ahmedabad', status: CityStatus.COMING_SOON },
  });
  console.log('✅ Cities');

  // 4. Areas
  const areaNames = ['Adajan', 'Katargam', 'Varachha', 'Vesu'];
  const areas: Record<string, string> = {};
  for (const name of areaNames) {
    const area = await prisma.area.create({
      data: { name, cityId: surat.id, isActive: true },
    });
    areas[name] = area.id;
  }
  console.log('✅ Areas');

  // 5. Categories
  const categoryDefs = [
    { name: 'Food',    slug: 'food',    iconName: 'restaurant'   },
    { name: 'Salon',   slug: 'salon',   iconName: 'content_cut'  },
    { name: 'Theater', slug: 'theater', iconName: 'theaters'     },
    { name: 'Spa',     slug: 'spa',     iconName: 'spa'          },
    { name: 'Cafe',    slug: 'cafe',    iconName: 'coffee'       },
    { name: 'Other',   slug: 'other',   iconName: 'category'     },
  ];
  const catMap: Record<string, string> = {};
  for (const cat of categoryDefs) {
    const c = await prisma.category.create({ data: cat });
    catMap[cat.slug] = c.id;
  }
  console.log('✅ Categories');

  // 6. Sellers (3 active)
  await prisma.seller.create({
    data: {
      businessName: 'SR Cafe',
      categoryId: catMap['cafe'],
      cityId: surat.id,
      areaId: areas['Adajan'],
      phone: '9876543210',
      email: 'contact@srcafe.com',
      upiId: 'srcafe@upi',
      address: '101, VIP Road, Adajan',
      latitude: 21.1702,
      longitude: 72.8311,
      operatingHours: 'Mon-Sun, 10am-11pm',
      commissionPct: 5,
      status: SellerStatus.ACTIVE,
      media: {
        create: {
          logoUrl: 'https://placehold.co/150x150/png?text=Cafe',
          photoUrl1: 'https://placehold.co/600x400/png?text=SR+Cafe',
        }
      }
    }
  });

  await prisma.seller.create({
    data: {
      businessName: 'Fancy Salon & Spa',
      categoryId: catMap['salon'],
      cityId: surat.id,
      areaId: areas['Vesu'],
      phone: '9876543211',
      email: 'contact@fancysalon.com',
      upiId: 'fancysalon@upi',
      address: '202, Green Avenue, Vesu',
      latitude: 21.1418,
      longitude: 72.7709,
      operatingHours: 'Tue-Sun, 9am-8pm',
      commissionPct: 10,
      status: SellerStatus.ACTIVE,
      media: {
        create: {
          logoUrl: 'https://placehold.co/150x150/png?text=Salon',
          photoUrl1: 'https://placehold.co/600x400/png?text=Fancy+Salon',
        }
      }
    }
  });

  await prisma.seller.create({
    data: {
      businessName: 'Grand Cinemas',
      categoryId: catMap['theater'],
      cityId: surat.id,
      areaId: areas['Varachha'],
      phone: '9876543212',
      email: 'contact@grandcinemas.com',
      upiId: 'grandcinemas@upi',
      address: '303, Main Road, Varachha',
      latitude: 21.1892,
      longitude: 72.7933,
      operatingHours: 'Mon-Sun, 10am-11pm',
      commissionPct: 8,
      status: SellerStatus.ACTIVE,
      media: {
        create: {
          logoUrl: 'https://placehold.co/150x150/png?text=Cinema',
          photoUrl1: 'https://placehold.co/600x400/png?text=Grand+Cinemas',
        }
      }
    }
  });

  console.log('✅ Sellers (3 active)');

  console.log('\n🎉 Seed complete!');
  console.log('   Admin email:    admin@couponapp.in');
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
