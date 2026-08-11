import { prisma } from '../../../config/db';
import { Prisma } from '@prisma/client';
import type { AdminPaymentsQueryDto, PaginatedPaymentAttemptsResponse } from './admin-payments.validator';

export class AdminPaymentsService {

  // ─── List Payment Attempts ─────────────────────────────────────────────────────
  async listPayments(query: AdminPaymentsQueryDto): Promise<PaginatedPaymentAttemptsResponse> {
    const { page, limit, status, kind, userId } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.PaymentAttemptWhereInput = {};
    if (status) where.status = status;
    if (kind)   where.kind = kind;
    if (userId) where.userId = userId;

    const [attempts, total] = await Promise.all([
      prisma.paymentAttempt.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id:                true,
          userId:            true,
          subscriptionId:    true,
          razorpayOrderId:   true,
          razorpayPaymentId: true,
          razorpayTokenId:   true,
          amount:            true,
          kind:              true,
          status:            true,
          errorCode:         true,
          errorDescription:  true,
          createdAt:         true,
          user: { select: { name: true, phone: true } },
        },
      }),
      prisma.paymentAttempt.count({ where }),
    ]);

    return {
      data: attempts as any,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}
