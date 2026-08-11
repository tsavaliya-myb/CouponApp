import { useQuery } from "@tanstack/react-query";
import { getPayments } from "@/services/payments.service";
import { GetPaymentsParams } from "@/types/api/payments";

export const usePayments = (params?: GetPaymentsParams) => {
  return useQuery({
    queryKey: ["payments", params],
    queryFn: () => getPayments(params),
  });
};
