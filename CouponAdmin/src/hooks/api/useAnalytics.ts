import { useQuery } from "@tanstack/react-query";
import * as Service from "@/services/analytics.service";
import * as Types from "@/types/api/analytics";

export const useAnalyticsSubscriptions = (groupBy: "day" | "week" | "month" = "month") => {
  return useQuery({
    queryKey: ["analytics", "subscriptions", groupBy],
    queryFn: () => Service.getAnalyticsSubscriptions({ groupBy }),
  });
};

export const useAnalyticsRedemptions = (params: Types.AnalyticsRedemptionsParams) => {
  return useQuery({
    queryKey: ["analytics", "redemptions", params],
    queryFn: () => Service.getAnalyticsRedemptions(params),
  });
};

export const useAnalyticsTopSellers = (params?: { startDate?: string; endDate?: string; limit?: number }) => {
  return useQuery({
    queryKey: ["analytics", "topSellers", params],
    queryFn: () => Service.getAnalyticsTopSellers(params || { limit: 10 }),
  });
};

export const useAnalyticsTopCoupons = (params?: { startDate?: string; endDate?: string; limit?: number }) => {
  return useQuery({
    queryKey: ["analytics", "topCoupons", params],
    queryFn: () => Service.getAnalyticsTopCoupons(params || { limit: 10 }),
  });
};

export const useAnalyticsCoins = () => {
  return useQuery({
    queryKey: ["analytics", "coins"],
    queryFn: Service.getAnalyticsCoins,
  });
};

export const useAnalyticsChurn = () => {
  return useQuery({
    queryKey: ["analytics", "churn"],
    queryFn: Service.getAnalyticsChurn,
  });
};

export const useAnalyticsCategoryRedemptions = (params?: { startDate?: string; endDate?: string }) => {
  return useQuery({
    queryKey: ["analytics", "categoryRedemptions", params],
    queryFn: () => Service.getAnalyticsCategoryRedemptions(params || {}),
  });
};

export const useAnalyticsRevenue = (groupBy: "day" | "week" | "year" = "year") => {
  return useQuery({
    queryKey: ["analytics", "revenue", groupBy],
    queryFn: () => Service.getAnalyticsRevenue({ groupBy }),
  });
};
