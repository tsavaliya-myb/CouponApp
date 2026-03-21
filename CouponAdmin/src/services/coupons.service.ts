import { apiClient } from "@/lib/apiClient";
import { CouponsResponse, GetCouponsParams, CouponStatusResponse, CreateCouponParams, UpdateCouponParams } from "@/types/api/coupons";

export const getCoupons = async (params?: GetCouponsParams): Promise<CouponsResponse> => {
  const { data } = await apiClient.get<CouponsResponse>("/admin/coupons", {
    params,
  });
  return data;
};

export const createCoupon = async (payload: CreateCouponParams): Promise<CouponStatusResponse> => {
  const { data } = await apiClient.post<CouponStatusResponse>("/admin/coupons", payload);
  return data;
};

export const updateCoupon = async (id: string, payload: UpdateCouponParams): Promise<CouponStatusResponse> => {
  const { data } = await apiClient.patch<CouponStatusResponse>(`/admin/coupons/${id}`, payload);
  return data;
};

export const toggleCouponStatus = async (id: string): Promise<CouponStatusResponse> => {
  const { data } = await apiClient.patch<CouponStatusResponse>(`/admin/coupons/${id}/toggle-status`);
  return data;
};
