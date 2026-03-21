import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getWalletSettings, updateWalletSettings, bulkAwardCoins, getWalletOverview } from "@/services/wallet.service";
import { UpdateWalletSettingsParams, BulkAwardParams } from "@/types/api/wallet";

export const useWalletSettings = () => {
  return useQuery({
    queryKey: ["walletSettings"],
    queryFn: getWalletSettings,
  });
};

export const useUpdateWalletSettings = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: UpdateWalletSettingsParams) => updateWalletSettings(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["walletSettings"] });
    },
  });
};

export const useBulkAwardCoins = () => {
  return useMutation({
    mutationFn: (data: BulkAwardParams) => bulkAwardCoins(data),
  });
};

export const useWalletOverview = () => {
  return useQuery({
    queryKey: ["walletOverview"],
    queryFn: getWalletOverview,
  });
};
