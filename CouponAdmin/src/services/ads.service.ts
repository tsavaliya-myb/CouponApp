import { apiClient } from "@/lib/apiClient";
import {
  BannerAdsResponse,
  BannerAdResponse,
  CreateBannerAdPayload,
  UpdateBannerAdPayload,
  GetBannerAdsParams,
} from "@/types/api/ads";

const BASE = "/ads/admin/banners";

export const getBannerAds = async (params?: GetBannerAdsParams): Promise<BannerAdsResponse> => {
  const { data } = await apiClient.get<any>(BASE, { params });
  // Normalize: old API wraps {data, meta} inside data; new API puts them at root
  if (Array.isArray(data.data)) return data as BannerAdsResponse;
  return { success: data.success, data: data.data?.data ?? [], meta: data.data?.meta ?? data.meta };
};

export const getBannerAd = async (id: string): Promise<BannerAdResponse> => {
  const { data } = await apiClient.get<BannerAdResponse>(`${BASE}/${id}`);
  return data;
};

export const createBannerAd = async (payload: CreateBannerAdPayload): Promise<BannerAdResponse> => {
  const { data } = await apiClient.post<BannerAdResponse>(BASE, payload);
  return data;
};

export const updateBannerAd = async (id: string, payload: UpdateBannerAdPayload): Promise<BannerAdResponse> => {
  const { data } = await apiClient.patch<BannerAdResponse>(`${BASE}/${id}`, payload);
  return data;
};

export const pauseBannerAd = async (id: string): Promise<BannerAdResponse> => {
  const { data } = await apiClient.patch<BannerAdResponse>(`${BASE}/${id}/pause`);
  return data;
};

export const resumeBannerAd = async (id: string): Promise<BannerAdResponse> => {
  const { data } = await apiClient.patch<BannerAdResponse>(`${BASE}/${id}/resume`);
  return data;
};

export const deleteBannerAd = async (id: string): Promise<void> => {
  await apiClient.delete(`${BASE}/${id}`);
};
