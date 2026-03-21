import { useQuery } from "@tanstack/react-query";
import { getNotificationHistory } from "@/services/notification.service";

export const useNotificationHistory = (params: { page?: number; limit?: number } = { page: 1, limit: 20 }) => {
  return useQuery({
    queryKey: ["notifications", "history", params],
    queryFn: () => getNotificationHistory(params),
  });
};
