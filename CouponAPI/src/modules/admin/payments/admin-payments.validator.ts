import { z } from 'zod';
import { PAGINATION } from '../../../shared/constants';

// ─── Query Params Validation for Admin Payments List ───────────────────────────
export const adminPaymentsQuerySchema = z.object({
  page:   z.coerce.number().min(1).default(PAGINATION.DEFAULT_PAGE),
  limit:  z.coerce.number().min(1).max(PAGINATION.MAX_LIMIT).default(PAGINATION.DEFAULT_LIMIT),
  status: z.enum(['PENDING', 'SUCCESS', 'FAILED', 'CANCELLED']).optional(),
  kind:   z.enum(['MANDATE', 'RENEWAL']).optional(),
  userId: z.string().uuid().optional(),
});

export type AdminPaymentsQueryDto = z.infer<typeof adminPaymentsQuerySchema>;

// ─── Response Schemas ───────────────────────────────────────────────────────────

export const paymentAttemptResponseSchema = z.object({
  id:                z.string().uuid(),
  userId:            z.string().uuid(),
  subscriptionId:    z.string().uuid().nullable(),
  razorpayOrderId:   z.string(),
  razorpayPaymentId: z.string().nullable(),
  razorpayTokenId:   z.string().nullable(),
  amount:            z.string(),
  kind:              z.string(),
  status:            z.string(),
  errorCode:         z.string().nullable(),
  errorDescription:  z.string().nullable(),
  createdAt:         z.date().or(z.string()),
  user: z.object({
    name:  z.string().nullable(),
    phone: z.string(),
  }).optional(),
});

export const paginatedPaymentAttemptsResponseSchema = z.object({
  data: z.array(paymentAttemptResponseSchema),
  meta: z.object({
    total:      z.number(),
    page:       z.number(),
    limit:      z.number(),
    totalPages: z.number(),
  }),
});

export type PaymentAttemptResponse = z.infer<typeof paymentAttemptResponseSchema>;
export type PaginatedPaymentAttemptsResponse = z.infer<typeof paginatedPaymentAttemptsResponseSchema>;
