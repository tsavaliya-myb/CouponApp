import { apiClient } from "@/lib/apiClient";
import { PaymentsResponse, GetPaymentsParams } from "@/types/api/payments";

export const getPayments = async (params?: GetPaymentsParams): Promise<PaymentsResponse> => {
  const { data } = await apiClient.get<PaymentsResponse>("/admin/payments", {
    params,
  });
  return data;
};
