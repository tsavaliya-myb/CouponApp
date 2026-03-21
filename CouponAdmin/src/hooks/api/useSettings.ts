import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getSystemSettings, updateSystemSettings } from "@/services/settings.service";

export const useSystemSettings = () => {
  return useQuery({
    queryKey: ["settings", "system"],
    queryFn: getSystemSettings,
  });
};

export const useUpdateSystemSettings = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: updateSystemSettings,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["settings"] });
      queryClient.invalidateQueries({ queryKey: ["wallet"] }); // Since wallet shares config visualizers
    }
  });
};
