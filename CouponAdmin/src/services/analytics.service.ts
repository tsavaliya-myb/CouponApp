import { apiClient } from "@/lib/apiClient";
import * as Types from "@/types/api/analytics";

export const getAnalyticsSubscriptions = async (params: { groupBy: string }): Promise<Types.AnalyticsSubscriptionsResponse> => {
  const { data } = await apiClient.get("/admin/analytics/subscriptions", { params });
  return data;
};

export const getAnalyticsRedemptions = async (params: Types.AnalyticsRedemptionsParams): Promise<Types.AnalyticsRedemptionsResponse> => {
  const { data } = await apiClient.get("/admin/analytics/redemptions", { params });
  return data;
};

export const getAnalyticsTopSellers = async (params: { startDate?: string; endDate?: string; limit?: number }): Promise<Types.AnalyticsTopSellersResponse> => {
  const { data } = await apiClient.get("/admin/analytics/sellers/top", { params });
  return data;
};

export const getAnalyticsTopCoupons = async (params: { startDate?: string; endDate?: string; limit?: number }): Promise<Types.AnalyticsTopCouponsResponse> => {
  const { data } = await apiClient.get("/admin/analytics/coupons/top", { params });
  return data;
};

export const getAnalyticsCoins = async (): Promise<Types.AnalyticsCoinsResponse> => {
  const { data } = await apiClient.get("/admin/analytics/coins");
  return data;
};

export const getAnalyticsChurn = async (): Promise<Types.AnalyticsChurnResponse> => {
  const { data } = await apiClient.get("/admin/analytics/churn");
  return data;
};

export const getAnalyticsCategoryRedemptions = async (params: { startDate?: string; endDate?: string }): Promise<Types.AnalyticsCategoryRedemptionsResponse> => {
  const { data } = await apiClient.get("/admin/analytics/redemptions/category", { params });
  return data;
};

export const getAnalyticsRevenue = async (params: { groupBy: "day" | "week" | "year" }): Promise<Types.AnalyticsRevenueResponse> => {
  const { data } = await apiClient.get("/admin/analytics/revenue", { params });
  return data;
};
