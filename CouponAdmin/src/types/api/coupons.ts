import { PaginatedMeta } from "./users";

export interface CouponSeller {
  businessName: string;
  city: {
    name: string;
  };
}

export interface Coupon {
  id: string;
  sellerId: string;
  discountPct: number;
  adminCommissionPct: number;
  minSpend: number | null;
  maxUsesPerBook: number;
  type: "STANDARD" | "BOGO" | string;
  status: "ACTIVE" | "INACTIVE" | "EXPIRED" | string;
  isBaseCoupon: boolean;
  totalRedemptions?: number;
  createdAt: string;
  updatedAt: string;
  seller: CouponSeller;
}

export interface CouponsResponse {
  success: boolean;
  data: Coupon[];
  meta: PaginatedMeta;
}

export interface CouponStatusResponse {
  success: boolean;
  data: Coupon;
}

export interface CreateCouponParams {
  sellerId: string;
  discountPct: number;
  adminCommissionPct: number;
  minSpend?: number;
  maxUsesPerBook: number;
  type: string;
  isBaseCoupon: boolean;
}

export interface UpdateCouponParams {
  discountPct?: number;
  adminCommissionPct?: number;
  minSpend?: number;
  maxUsesPerBook?: number;
  type?: string;
  isBaseCoupon?: boolean;
}

export interface GetCouponsParams {
  page?: number;
  limit?: number;
  sellerId?: string;
  cityId?: string;
  type?: string;
}
