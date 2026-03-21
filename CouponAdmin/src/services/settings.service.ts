import { apiClient } from "@/lib/apiClient";
import { SystemSettingsResponse, UpdateSystemSettingsPayload } from "@/types/api/settings";

export const getSystemSettings = async (): Promise<SystemSettingsResponse> => {
  const { data } = await apiClient.get<SystemSettingsResponse>("/admin/settings");
  return data;
};

export const updateSystemSettings = async (payload: UpdateSystemSettingsPayload): Promise<SystemSettingsResponse> => {
  const { data } = await apiClient.patch<SystemSettingsResponse>("/admin/settings", payload);
  return data;
};
