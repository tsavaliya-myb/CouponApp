import { apiClient } from "@/lib/apiClient";
import { DashboardResponse } from "@/types/api/dashboard";

export const getDashboardStats = async (): Promise<DashboardResponse> => {
  const { data } = await apiClient.get<DashboardResponse>("/admin/dashboard");
  return data;
};
