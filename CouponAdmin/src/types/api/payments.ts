import { PaginatedMeta } from "./users";

export type PaymentAttemptStatus = "PENDING" | "SUCCESS" | "FAILED" | "CANCELLED";
export type PaymentAttemptKind = "MANDATE" | "RENEWAL";

export interface PaymentAttempt {
  id: string;
  userId: string;
  subscriptionId: string | null;
  razorpayOrderId: string;
  razorpayPaymentId: string | null;
  razorpayTokenId: string | null;
  amount: string;
  kind: PaymentAttemptKind | string;
  status: PaymentAttemptStatus | string;
  errorCode: string | null;
  errorDescription: string | null;
  createdAt: string;
  user?: {
    name: string | null;
    phone: string;
  };
}

export interface PaymentsResponse {
  success: boolean;
  data: PaymentAttempt[];
  meta: PaginatedMeta;
}

export interface GetPaymentsParams {
  page?: number;
  limit?: number;
  status?: PaymentAttemptStatus;
  kind?: PaymentAttemptKind;
  userId?: string;
}
