import { PaginatedMeta } from "./users";

export interface SettlementSeller {
  businessName: string;
  phone: string;
}

export interface Settlement {
  id: string;
  sellerId: string;
  weekStart: string;
  weekEnd: string;
  commissionTotal: number;
  commissionStatus: "PENDING" | "PAID" | string;
  commissionPaidAt: string | null;
  coinCompensationTotal: number;
  coinCompStatus: "PENDING" | "PAID" | string;
  coinCompPaidAt: string | null;
  createdAt: string;
  updatedAt: string;
  seller: SettlementSeller;
}

export interface SettlementsResponse {
  success: boolean;
  data: Settlement[];
  meta: PaginatedMeta;
}

export interface SettlementStatusResponse {
  success: boolean;
  data: Settlement;
}

export interface MarkSettlementPaidParams {
  commissionPaid?: boolean;
  coinCompPaid?: boolean;
}

export interface GetSettlementsParams {
  page?: number;
  limit?: number;
  sellerId?: string;
}
