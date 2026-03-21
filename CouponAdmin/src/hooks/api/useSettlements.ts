import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getSettlements, markSettlementPaid } from "@/services/settlements.service";
import { GetSettlementsParams, MarkSettlementPaidParams } from "@/types/api/settlements";

export const useSettlements = (params?: GetSettlementsParams) => {
  return useQuery({
    queryKey: ["settlements", params],
    queryFn: () => getSettlements(params),
  });
};

export const useMarkSettlementPaid = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: MarkSettlementPaidParams }) => markSettlementPaid(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["settlements"] });
    },
  });
};
