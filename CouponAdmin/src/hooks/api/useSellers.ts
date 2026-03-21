import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getSellers, approveSeller, suspendSeller, updateSeller, rejectSeller } from "@/services/sellers.service";
import { GetSellersParams, UpdateSellerParams } from "@/types/api/sellers";

export const useSellers = (params?: GetSellersParams) => {
  return useQuery({
    queryKey: ["sellers", params],
    queryFn: () => getSellers(params),
  });
};

export const useUpdateSeller = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateSellerParams }) => updateSeller(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sellers"] });
    },
  });
};

export const useApproveSeller = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => approveSeller(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sellers"] });
      // If we had a direct 'seller' detail query hook, we'd invalidate that too
    },
  });
};

export const useRejectSeller = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => rejectSeller(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sellers"] });
    },
  });
};

export const useSuspendSeller = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => suspendSeller(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sellers"] });
    },
  });
};
