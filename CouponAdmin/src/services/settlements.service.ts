import { apiClient } from "@/lib/apiClient";
import { SettlementsResponse, GetSettlementsParams, SettlementStatusResponse, MarkSettlementPaidParams } from "@/types/api/settlements";

export const getSettlements = async (params?: GetSettlementsParams): Promise<SettlementsResponse> => {
  const { data } = await apiClient.get<SettlementsResponse>("/admin/settlements", {
    params,
  });
  return data;
};

export const markSettlementPaid = async (id: string, payload: MarkSettlementPaidParams): Promise<SettlementStatusResponse> => {
  const { data } = await apiClient.patch<SettlementStatusResponse>(`/admin/settlements/${id}/mark-paid`, payload);
  return data;
};
