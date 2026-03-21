import { PaginatedMeta, City, Area } from "./users";

export interface Seller {
  id: string;
  businessName: string;
  category: string;
  cityId: string;
  areaId: string;
  address: string | null;
  phone: string;
  email: string | null;
  upiId: string | null;
  latitude: number | null;
  longitude: number | null;
  operatingHours: string | null;
  commissionPct: number;
  status: "ACTIVE" | "INACTIVE" | "BLOCKED" | string;
  onesignalPlayerId: string | null;
  createdAt: string;
  updatedAt: string;
  city: {
    name: string;
  };
  area: {
    name: string;
  };
}

export interface SellersResponse {
  success: boolean;
  data: Seller[];
  meta: PaginatedMeta;
}

export interface SellerStatusResponse {
  success: boolean;
  data: Seller;
}

export interface UpdateSellerParams {
  businessName?: string;
  category?: string;
  cityId?: string;
  areaId?: string;
  upiId?: string;
  lat?: number;
  lng?: number;
  commissionPct?: number;
}

export interface GetSellersParams {
  page?: number;
  limit?: number;
  search?: string;
  status?: string;
  category?: string;
  cityId?: string;
  areaId?: string;
}
