import { apiClient } from "@/lib/apiClient";
import { WalletSettingsResponse, UpdateWalletSettingsParams, BulkAwardParams, BulkAwardResponse, WalletOverviewResponse } from "@/types/api/wallet";

export const getWalletSettings = async (): Promise<WalletSettingsResponse> => {
  const { data } = await apiClient.get<WalletSettingsResponse>("/admin/wallet/settings");
  return data;
};

export const updateWalletSettings = async (payload: UpdateWalletSettingsParams): Promise<WalletSettingsResponse> => {
  const { data } = await apiClient.patch<WalletSettingsResponse>("/admin/wallet/settings", payload);
  return data;
};

export const bulkAwardCoins = async (payload: BulkAwardParams): Promise<BulkAwardResponse> => {
  const { data } = await apiClient.post<BulkAwardResponse>("/admin/wallet/bulk-award", payload);
  return data;
};

export const getWalletOverview = async (): Promise<WalletOverviewResponse> => {
  const { data } = await apiClient.get<WalletOverviewResponse>("/admin/wallet/overview");
  return data;
};
