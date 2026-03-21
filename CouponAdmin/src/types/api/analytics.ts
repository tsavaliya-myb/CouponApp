export interface AnalyticsSubscriptionsResponse {
  success: boolean;
  data: {
    totalCount: number;
    totalRevenue: number;
  };
}

export interface AnalyticsRedemptionsParams {
  startDate?: string;
  endDate?: string;
  groupBy?: "day" | "week" | "month";
  cityId?: string;
  categoryId?: string;
  sellerId?: string;
}

export interface AnalyticsRedemptionsResponse {
  success: boolean;
  data: {
    totalRedemptions: number;
  };
}

export interface TopSellerAnalytics {
  sellerId: string;
  businessName: string;
  redemptions: number;
}

export interface AnalyticsTopSellersResponse {
  success: boolean;
  data: TopSellerAnalytics[];
}

export interface TopCouponAnalytics {
  userCouponId: string;
  title: string;
  type: string;
  redemptions: number;
}

export interface AnalyticsTopCouponsResponse {
  success: boolean;
  data: TopCouponAnalytics[];
}

export interface CategoryRedemptionAnalytics {
  category: string;
  redemptions: number;
}

export interface AnalyticsCategoryRedemptionsResponse {
  success: boolean;
  data: CategoryRedemptionAnalytics[];
}

export interface AnalyticsCoinsResponse {
  success: boolean;
  data: {
    totalAwarded: number;
    awardedTxCount: number;
    totalUsed: number;
    usedTxCount: number;
  };
}

export interface AnalyticsChurnResponse {
  success: boolean;
  data: {
    activeSubscriptions: number;
    expiredSubscriptions: number;
  };
}

export interface RevenueAnalytics {
  label: string;
  subscriptionRevenue: number;
  commissionRevenue: number;
  totalRevenue: number;
}

export interface AnalyticsRevenueResponse {
  success: boolean;
  data: RevenueAnalytics[];
}
