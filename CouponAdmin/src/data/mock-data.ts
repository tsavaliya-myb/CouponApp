// ── Types ──

export interface User {
  id: string;
  name: string;
  phone: string;
  email: string;
  city: string;
  area: string;
  status: "active" | "expired";
  joinDate: string;
  coinBalance: number;
  subscriptionExpiry: string;
}

export interface Seller {
  id: string;
  businessName: string;
  category: string;
  city: string;
  area: string;
  phone: string;
  email: string;
  commission: number;
  status: "pending" | "active" | "suspended";
  joinDate: string;
  totalRedemptions: number;
  upiId: string;
}

export interface Coupon {
  id: string;
  name: string;
  sellerId: string;
  sellerName: string;
  discountPercent: number;
  commissionPercent: number;
  minSpend: number;
  maxUses: number;
  usedCount: number;
  type: "percentage" | "bogo" | "flat";
  status: "active" | "inactive";
  totalRedemptions: number;
  commissionGenerated: number;
}

export interface Redemption {
  id: string;
  userId: string;
  userName: string;
  sellerId: string;
  sellerName: string;
  couponName: string;
  billAmount: number;
  discountAmount: number;
  coinsUsed: number;
  finalAmount: number;
  date: string;
}

export interface CoinTransaction {
  id: string;
  userId: string;
  userName: string;
  type: "earned" | "used";
  amount: number;
  context: string;
  date: string;
}

export interface Settlement {
  id: string;
  sellerId: string;
  sellerName: string;
  weekLabel: string;
  totalRedemptions: number;
  commissionAmount: number;
  commissionStatus: "pending" | "paid";
  coinsUsed: number;
  coinCompensation: number;
  coinCompensationStatus: "pending" | "paid";
  date: string;
}

export interface Notification {
  id: string;
  title: string;
  message: string;
  audience: "all" | "city" | "area" | "expiring";
  city?: string;
  area?: string;
  sentAt: string;
  deliveredCount: number;
  status: "sent" | "scheduled" | "draft";
}

export interface City {
  id: string;
  name: string;
  status: "active" | "coming_soon";
  areas: CityArea[];
}

export interface CityArea {
  id: string;
  name: string;
  active: boolean;
}

// ── Mock Data ──

export const mockUsers: User[] = [
  { id: "u1", name: "Aarav Patel", phone: "9876543210", email: "aarav@email.com", city: "Surat", area: "Adajan", status: "active", joinDate: "2026-01-15", coinBalance: 42, subscriptionExpiry: "2026-04-01" },
  { id: "u2", name: "Priya Sharma", phone: "9876543211", email: "priya@email.com", city: "Surat", area: "Vesu", status: "active", joinDate: "2026-02-03", coinBalance: 18, subscriptionExpiry: "2026-04-15" },
  { id: "u3", name: "Rohan Desai", phone: "9876543212", email: "rohan@email.com", city: "Surat", area: "Katargam", status: "expired", joinDate: "2025-11-20", coinBalance: 5, subscriptionExpiry: "2026-01-05" },
  { id: "u4", name: "Meera Joshi", phone: "9876543213", email: "meera@email.com", city: "Surat", area: "Adajan", status: "active", joinDate: "2026-03-01", coinBalance: 50, subscriptionExpiry: "2026-04-20" },
  { id: "u5", name: "Karan Mehta", phone: "9876543214", email: "karan@email.com", city: "Surat", area: "Vesu", status: "active", joinDate: "2026-01-28", coinBalance: 7, subscriptionExpiry: "2026-03-30" },
  { id: "u6", name: "Anjali Reddy", phone: "9876543215", email: "anjali@email.com", city: "Surat", area: "Athwa", status: "expired", joinDate: "2025-12-10", coinBalance: 0, subscriptionExpiry: "2026-02-01" },
  { id: "u7", name: "Vikram Singh", phone: "9876543216", email: "vikram@email.com", city: "Surat", area: "Piplod", status: "active", joinDate: "2026-02-14", coinBalance: 33, subscriptionExpiry: "2026-04-10" },
  { id: "u8", name: "Neha Gupta", phone: "9876543217", email: "neha@email.com", city: "Surat", area: "Katargam", status: "active", joinDate: "2026-03-05", coinBalance: 50, subscriptionExpiry: "2026-04-25" },
];

export const mockSellers: Seller[] = [
  { id: "s1", businessName: "Spice Garden", category: "Food", city: "Surat", area: "Adajan", phone: "9812345670", email: "spice@email.com", commission: 5, status: "active", joinDate: "2025-10-01", totalRedemptions: 187, upiId: "spicegarden@upi" },
  { id: "s2", businessName: "Glamour Studio", category: "Salon", city: "Surat", area: "Vesu", phone: "9812345671", email: "glamour@email.com", commission: 7, status: "active", joinDate: "2025-11-15", totalRedemptions: 94, upiId: "glamour@upi" },
  { id: "s3", businessName: "Cinema Palace", category: "Theater", city: "Surat", area: "Athwa", phone: "9812345672", email: "cinema@email.com", commission: 4, status: "active", joinDate: "2025-09-20", totalRedemptions: 312, upiId: "cinema@upi" },
  { id: "s4", businessName: "Zen Spa & Wellness", category: "Spa", city: "Surat", area: "Piplod", phone: "9812345673", email: "zen@email.com", commission: 6, status: "pending", joinDate: "2026-03-10", totalRedemptions: 0, upiId: "zen@upi" },
  { id: "s5", businessName: "Brew & Bite Cafe", category: "Cafe", city: "Surat", area: "Adajan", phone: "9812345674", email: "brew@email.com", commission: 5, status: "active", joinDate: "2026-01-05", totalRedemptions: 63, upiId: "brew@upi" },
  { id: "s6", businessName: "Tandoori Nights", category: "Food", city: "Surat", area: "Katargam", phone: "9812345675", email: "tandoori@email.com", commission: 5, status: "suspended", joinDate: "2025-08-12", totalRedemptions: 41, upiId: "tandoori@upi" },
  { id: "s7", businessName: "Fresh Cuts Salon", category: "Salon", city: "Surat", area: "Vesu", phone: "9812345676", email: "freshcuts@email.com", commission: 6, status: "pending", joinDate: "2026-03-15", totalRedemptions: 0, upiId: "freshcuts@upi" },
];

export const mockCoupons: Coupon[] = [
  { id: "c1", name: "20% Off Lunch", sellerId: "s1", sellerName: "Spice Garden", discountPercent: 20, commissionPercent: 5, minSpend: 500, maxUses: 3, usedCount: 187, type: "percentage", status: "active", totalRedemptions: 187, commissionGenerated: 4675 },
  { id: "c2", name: "Flat 15% on Haircut", sellerId: "s2", sellerName: "Glamour Studio", discountPercent: 15, commissionPercent: 7, minSpend: 300, maxUses: 2, usedCount: 94, type: "percentage", status: "active", totalRedemptions: 94, commissionGenerated: 1974 },
  { id: "c3", name: "Buy 1 Get 1 Ticket", sellerId: "s3", sellerName: "Cinema Palace", discountPercent: 50, commissionPercent: 4, minSpend: 0, maxUses: 1, usedCount: 312, type: "bogo", status: "active", totalRedemptions: 312, commissionGenerated: 3744 },
  { id: "c4", name: "25% Off Spa Session", sellerId: "s4", sellerName: "Zen Spa & Wellness", discountPercent: 25, commissionPercent: 6, minSpend: 1000, maxUses: 2, usedCount: 0, type: "percentage", status: "inactive", totalRedemptions: 0, commissionGenerated: 0 },
  { id: "c5", name: "10% Off All Beverages", sellerId: "s5", sellerName: "Brew & Bite Cafe", discountPercent: 10, commissionPercent: 5, minSpend: 200, maxUses: 5, usedCount: 63, type: "percentage", status: "active", totalRedemptions: 63, commissionGenerated: 630 },
  { id: "c6", name: "30% Off Dinner", sellerId: "s1", sellerName: "Spice Garden", discountPercent: 30, commissionPercent: 5, minSpend: 800, maxUses: 2, usedCount: 45, type: "percentage", status: "active", totalRedemptions: 45, commissionGenerated: 1800 },
];

export const mockRedemptions: Redemption[] = [
  { id: "r1", userId: "u1", userName: "Aarav Patel", sellerId: "s1", sellerName: "Spice Garden", couponName: "20% Off Lunch", billAmount: 1200, discountAmount: 240, coinsUsed: 10, finalAmount: 950, date: "2026-03-19" },
  { id: "r2", userId: "u2", userName: "Priya Sharma", sellerId: "s2", sellerName: "Glamour Studio", couponName: "Flat 15% on Haircut", billAmount: 800, discountAmount: 120, coinsUsed: 0, finalAmount: 680, date: "2026-03-19" },
  { id: "r3", userId: "u4", userName: "Meera Joshi", sellerId: "s3", sellerName: "Cinema Palace", couponName: "Buy 1 Get 1 Ticket", billAmount: 500, discountAmount: 250, coinsUsed: 5, finalAmount: 245, date: "2026-03-18" },
  { id: "r4", userId: "u5", userName: "Karan Mehta", sellerId: "s5", sellerName: "Brew & Bite Cafe", couponName: "10% Off All Beverages", billAmount: 350, discountAmount: 35, coinsUsed: 0, finalAmount: 315, date: "2026-03-18" },
  { id: "r5", userId: "u7", userName: "Vikram Singh", sellerId: "s1", sellerName: "Spice Garden", couponName: "30% Off Dinner", billAmount: 1500, discountAmount: 450, coinsUsed: 10, finalAmount: 1040, date: "2026-03-17" },
];

export const mockCoinTransactions: CoinTransaction[] = [
  { id: "ct1", userId: "u1", userName: "Aarav Patel", type: "earned", amount: 50, context: "Subscription purchase", date: "2026-01-15" },
  { id: "ct2", userId: "u1", userName: "Aarav Patel", type: "used", amount: 10, context: "Spice Garden redemption", date: "2026-03-19" },
  { id: "ct3", userId: "u2", userName: "Priya Sharma", type: "earned", amount: 50, context: "Subscription purchase", date: "2026-02-03" },
  { id: "ct4", userId: "u4", userName: "Meera Joshi", type: "earned", amount: 50, context: "Subscription purchase", date: "2026-03-01" },
  { id: "ct5", userId: "u4", userName: "Meera Joshi", type: "used", amount: 5, context: "Cinema Palace redemption", date: "2026-03-18" },
  { id: "ct6", userId: "u5", userName: "Karan Mehta", type: "earned", amount: 50, context: "Subscription purchase", date: "2026-01-28" },
  { id: "ct7", userId: "u7", userName: "Vikram Singh", type: "earned", amount: 50, context: "Subscription purchase", date: "2026-02-14" },
  { id: "ct8", userId: "u7", userName: "Vikram Singh", type: "used", amount: 10, context: "Spice Garden redemption", date: "2026-03-17" },
  { id: "ct9", userId: "u8", userName: "Neha Gupta", type: "earned", amount: 50, context: "Subscription purchase", date: "2026-03-05" },
];

export const mockSettlements: Settlement[] = [
  { id: "st1", sellerId: "s1", sellerName: "Spice Garden", weekLabel: "Mar 17–23", totalRedemptions: 14, commissionAmount: 2340, commissionStatus: "pending", coinsUsed: 20, coinCompensation: 20, coinCompensationStatus: "pending", date: "2026-03-23" },
  { id: "st2", sellerId: "s2", sellerName: "Glamour Studio", weekLabel: "Mar 17–23", totalRedemptions: 8, commissionAmount: 1120, commissionStatus: "pending", coinsUsed: 5, coinCompensation: 5, coinCompensationStatus: "pending", date: "2026-03-23" },
  { id: "st3", sellerId: "s3", sellerName: "Cinema Palace", weekLabel: "Mar 17–23", totalRedemptions: 22, commissionAmount: 1760, commissionStatus: "pending", coinsUsed: 15, coinCompensation: 15, coinCompensationStatus: "pending", date: "2026-03-23" },
  { id: "st4", sellerId: "s5", sellerName: "Brew & Bite Cafe", weekLabel: "Mar 17–23", totalRedemptions: 5, commissionAmount: 437, commissionStatus: "pending", coinsUsed: 0, coinCompensation: 0, coinCompensationStatus: "paid", date: "2026-03-23" },
  { id: "st5", sellerId: "s1", sellerName: "Spice Garden", weekLabel: "Mar 10–16", totalRedemptions: 18, commissionAmount: 3150, commissionStatus: "paid", coinsUsed: 30, coinCompensation: 30, coinCompensationStatus: "paid", date: "2026-03-16" },
  { id: "st6", sellerId: "s2", sellerName: "Glamour Studio", weekLabel: "Mar 10–16", totalRedemptions: 11, commissionAmount: 1540, commissionStatus: "paid", coinsUsed: 10, coinCompensation: 10, coinCompensationStatus: "paid", date: "2026-03-16" },
  { id: "st7", sellerId: "s3", sellerName: "Cinema Palace", weekLabel: "Mar 10–16", totalRedemptions: 28, commissionAmount: 2240, commissionStatus: "paid", coinsUsed: 18, coinCompensation: 18, coinCompensationStatus: "paid", date: "2026-03-16" },
];

export const mockNotifications: Notification[] = [
  { id: "n1", title: "Subscription Expiring Soon", message: "Your coupon book expires in 5 days. Renew now to keep saving!", audience: "expiring", sentAt: "2026-03-18T10:00:00", deliveredCount: 23, status: "sent" },
  { id: "n2", title: "New Restaurant Added!", message: "Brew & Bite Cafe is now on the platform. Check out their beverage coupons!", audience: "city", city: "Surat", sentAt: "2026-03-15T14:30:00", deliveredCount: 145, status: "sent" },
  { id: "n3", title: "Weekend Special", message: "Use your coupons this weekend and earn double coins!", audience: "all", sentAt: "2026-03-14T09:00:00", deliveredCount: 312, status: "sent" },
  { id: "n4", title: "Don't miss out!", message: "You have 3 unused coupons. Visit your favourite spots today!", audience: "all", sentAt: "2026-03-20T08:00:00", deliveredCount: 0, status: "scheduled" },
];

export const mockCities: City[] = [
  {
    id: "city1",
    name: "Surat",
    status: "active",
    areas: [
      { id: "a1", name: "Adajan", active: true },
      { id: "a2", name: "Vesu", active: true },
      { id: "a3", name: "Katargam", active: true },
      { id: "a4", name: "Athwa", active: true },
      { id: "a5", name: "Piplod", active: true },
      { id: "a6", name: "Varachha", active: false },
    ],
  },
  {
    id: "city2",
    name: "Ahmedabad",
    status: "coming_soon",
    areas: [
      { id: "a7", name: "Navrangpura", active: true },
      { id: "a8", name: "Satellite", active: true },
      { id: "a9", name: "Maninagar", active: true },
    ],
  },
  {
    id: "city3",
    name: "Vadodara",
    status: "coming_soon",
    areas: [
      { id: "a10", name: "Alkapuri", active: true },
      { id: "a11", name: "Fatehgunj", active: true },
    ],
  },
];

export const appSettings = {
  subscriptionPrice: 1000,
  bookValidityDays: 45,
  coinsPerSubscription: 50,
  maxCoinsPerTransaction: 10,
  notificationTemplates: {
    expiryReminder: "Your coupon book expires in {days} days. Renew now to keep saving!",
    welcome: "Welcome to CouponBook! You've received {coins} coins as a welcome bonus.",
    renewalSuccess: "Your coupon book has been renewed. You have {days} days of savings ahead!",
    coinCredit: "You've been awarded {coins} coins! Check your wallet for details.",
  },
};

// ── Dashboard stats ──

export const dashboardStats = {
  activeSubscribers: 6,
  revenueThisMonth: 47200,
  redemptionsToday: 2,
  redemptionsThisWeek: 5,
  pendingSettlements: 3,
  coinsAwardedThisMonth: 150,
  newSellerRequests: 2,
};

// ── Chart data ──

export const subscriptionChartData = [
  { date: "Mar 1", subscriptions: 3 },
  { date: "Mar 5", subscriptions: 5 },
  { date: "Mar 8", subscriptions: 2 },
  { date: "Mar 12", subscriptions: 7 },
  { date: "Mar 15", subscriptions: 4 },
  { date: "Mar 18", subscriptions: 6 },
  { date: "Mar 20", subscriptions: 3 },
];

export const redemptionChartData = [
  { date: "Mar 1", redemptions: 12 },
  { date: "Mar 5", redemptions: 18 },
  { date: "Mar 8", redemptions: 9 },
  { date: "Mar 12", redemptions: 24 },
  { date: "Mar 15", redemptions: 15 },
  { date: "Mar 18", redemptions: 21 },
  { date: "Mar 20", redemptions: 8 },
];

export const revenueChartData = [
  { month: "Oct", revenue: 12000, subscriptions: 8200, commission: 3800 },
  { month: "Nov", revenue: 18500, subscriptions: 12000, commission: 6500 },
  { month: "Dec", revenue: 24000, subscriptions: 16000, commission: 8000 },
  { month: "Jan", revenue: 31200, subscriptions: 21000, commission: 10200 },
  { month: "Feb", revenue: 38700, subscriptions: 25000, commission: 13700 },
  { month: "Mar", revenue: 47200, subscriptions: 30000, commission: 17200 },
];

export const categoryRedemptionData = [
  { category: "Food", redemptions: 273 },
  { category: "Salon", redemptions: 94 },
  { category: "Theater", redemptions: 312 },
  { category: "Cafe", redemptions: 63 },
  { category: "Spa", redemptions: 0 },
];

export const topSellers = [
  { name: "Cinema Palace", redemptions: 312, revenue: 3744 },
  { name: "Spice Garden", redemptions: 232, revenue: 6475 },
  { name: "Glamour Studio", redemptions: 94, revenue: 1974 },
  { name: "Brew & Bite Cafe", redemptions: 63, revenue: 630 },
  { name: "Tandoori Nights", redemptions: 41, revenue: 820 },
];

// ── Lookup helpers ──

export const cities = ["Surat"];
export const areasByCity: Record<string, string[]> = {
  Surat: ["Adajan", "Vesu", "Katargam", "Athwa", "Piplod"],
};
export const categories = ["Food", "Salon", "Theater", "Spa", "Cafe"];
