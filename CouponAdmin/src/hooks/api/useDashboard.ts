import { useQuery } from "@tanstack/react-query";
import { getDashboardStats } from "@/services/dashboard.service";

export const useDashboardStats = () => {
  return useQuery({
    queryKey: ["dashboardStats"],
    queryFn: getDashboardStats,
  });
};
