import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { paginatedPaymentAttemptsResponseSchema } from './admin-payments.validator';
import { PAGINATION } from '../../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code:    z.string(),
  message: z.string(),
});

// ─── ADMIN PAYMENTS ENDPOINTS ────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method:  'get',
  path:    '/admin/payments',
  summary: 'List Payment Attempts',
  description:
    'Lists PaymentAttempt records (MANDATE registrations and RENEWAL debits) with filtering and pagination. ' +
    'Lets support diagnose a failed purchase/renewal without reading server logs. Requires Admin Role.',
  tags:     ['Admin - Payments'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page:   z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit:  z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
      status: z.enum(['PENDING', 'SUCCESS', 'FAILED', 'CANCELLED']).optional(),
      kind:   z.enum(['MANDATE', 'RENEWAL']).optional(),
      userId: z.string().uuid().optional(),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: paginatedPaymentAttemptsResponseSchema.shape.data,
            meta: paginatedPaymentAttemptsResponseSchema.shape.meta,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});
