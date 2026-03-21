import { apiClient } from "@/lib/apiClient";
import { SellersResponse, GetSellersParams, SellerStatusResponse, UpdateSellerParams } from "@/types/api/sellers";

export const getSellers = async (params?: GetSellersParams): Promise<SellersResponse> => {
  const { data } = await apiClient.get<SellersResponse>("/admin/sellers", {
    params,
  });
  return data;
};

export const updateSeller = async (id: string, payload: UpdateSellerParams): Promise<SellerStatusResponse> => {
  const { data } = await apiClient.patch<SellerStatusResponse>(`/admin/sellers/${id}`, payload);
  return data;
};

export const approveSeller = async (id: string): Promise<SellerStatusResponse> => {
  const { data } = await apiClient.patch<SellerStatusResponse>(`/admin/sellers/${id}/approve`);
  return data;
};

export const rejectSeller = async (id: string): Promise<SellerStatusResponse> => {
  const { data } = await apiClient.patch<SellerStatusResponse>(`/admin/sellers/${id}/reject`);
  return data;
};

export const suspendSeller = async (id: string): Promise<SellerStatusResponse> => {
  const { data } = await apiClient.patch<SellerStatusResponse>(`/admin/sellers/${id}/suspend`);
  return data;
};
