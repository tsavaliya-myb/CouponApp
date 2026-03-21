export interface PaginatedMeta {
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface City {
  name: string;
}

export interface Area {
  name: string;
}

export interface User {
  id: string;
  phone: string;
  name: string;
  email: string | null;
  cityId: string | null;
  areaId: string | null;
  status: "ACTIVE" | "INACTIVE" | "BANNED" | "EXPIRED" | string;
  onesignalPlayerId: string | null;
  coinBalance: number;
  createdAt: string;
  updatedAt: string;
  city?: City;
  area?: Area;
}

export interface UsersResponse {
  success: boolean;
  data: User[];
  meta: PaginatedMeta;
}

export interface GetUsersParams {
  page?: number;
  limit?: number;
  search?: string;
  status?: string;
  cityId?: string;
  areaId?: string;
}

export interface UserSubscription {
  id: string;
  userId: string;
  startDate: string;
  endDate: string;
  status: string;
  razorpayOrderId: string | null;
  razorpayPaymentId: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface UserWalletTransaction {
  id: string;
  userId: string;
  type: "EARNED" | "USED" | string;
  amount: number;
  redemptionId: string | null;
  note: string;
  createdAt: string;
}

export interface UserRedemption {
  id: string;
  userCouponId: string;
  sellerId: string;
  userId: string;
  billAmount: number;
  discountAmount: number;
  coinsUsed: number;
  finalAmount: number;
  redeemedAt: string;
  seller: {
    businessName: string;
  };
  userCoupon: {
    id: string;
    couponBookId: string;
    couponId: string;
    usesRemaining: number;
    status: string;
    createdAt: string;
    updatedAt: string;
    coupon: {
      type: string;
      discountPct: number | null;
    };
  };
}

export interface UserDetail extends User {
  subscription: UserSubscription | null;
  wallet: UserWalletTransaction[];
  redemptions: UserRedemption[];
}

export interface UserDetailResponse {
  success: boolean;
  data: UserDetail;
}

export interface UserBlockResponse {
  success: boolean;
  data: User;
}


