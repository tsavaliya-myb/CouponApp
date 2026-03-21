import { apiClient } from "@/lib/apiClient";
import { NotificationHistoryResponse } from "@/types/api/notification";

export const getNotificationHistory = async (params: { page?: number; limit?: number }): Promise<NotificationHistoryResponse> => {
  const { data } = await apiClient.get<NotificationHistoryResponse>("/admin/notifications/history", { params });
  return data;
};
