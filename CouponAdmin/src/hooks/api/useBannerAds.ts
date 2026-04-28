import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  getBannerAds,
  createBannerAd,
  updateBannerAd,
  pauseBannerAd,
  resumeBannerAd,
  deleteBannerAd,
} from "@/services/ads.service";
import { GetBannerAdsParams, CreateBannerAdPayload, UpdateBannerAdPayload } from "@/types/api/ads";

const QK = "bannerAds";

export const useBannerAds = (params?: GetBannerAdsParams) =>
  useQuery({
    queryKey: [QK, params],
    queryFn: () => getBannerAds(params),
  });

export const useCreateBannerAd = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateBannerAdPayload) => createBannerAd(payload),
    onSuccess: () => qc.invalidateQueries({ queryKey: [QK] }),
  });
};

export const useUpdateBannerAd = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateBannerAdPayload }) =>
      updateBannerAd(id, data),
    onSuccess: () => qc.invalidateQueries({ queryKey: [QK] }),
  });
};

export const usePauseBannerAd = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => pauseBannerAd(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: [QK] }),
  });
};

export const useResumeBannerAd = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => resumeBannerAd(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: [QK] }),
  });
};

export const useDeleteBannerAd = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => deleteBannerAd(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: [QK] }),
  });
};
