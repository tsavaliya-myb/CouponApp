import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { 
  pendingSettlementsQuerySchema, 
  markPaidSchema,
  baseSettlementResponseSchema,
  paginatedSettlementsResponseSchema,
  exportCsvResponseSchema,
} from './admin-settlements.validator';
import { PAGINATION } from '../../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── ADMIN SETTLEMENTS ────────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/settlements',
  summary: 'List Pending Settlements',
  description: 'Lists all global settlements where either the Seller owes the Admin commission or the Admin owes the Seller Coin compensation. Requires Admin Role.',
  tags: ['Admin - Settlements'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
      sellerId: z.string().uuid().optional(),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: paginatedSettlementsResponseSchema.shape.data,
            meta: paginatedSettlementsResponseSchema.shape.meta,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/settlements/{id}/mark-paid',
  summary: 'Mark Settlement Paid',
  description: 'Records that a physical fiat payout has occurred for either Commision Owed (Seller Paid Us) or Coin Comp (We Paid Seller). Updates statuses from PENDING to PAID. Requires Admin Role.',
  tags: ['Admin - Settlements'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: markPaidSchema } },
    },
  },
  responses: {
    200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean(), data: baseSettlementResponseSchema }) } } },
    404: { description: 'Settlement Not Found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/settlements/export',
  summary: 'Export Settlements CSV',
  description: 'Triggers an asynchronous BullMQ worker to generate a CSV aggregate of the pending settlements. Yields a Job ID and a download URL representation. Requires Admin Role.',
  tags: ['Admin - Settlements'],
  security: [{ bearerAuth: [] }],
  responses: {
    202: {
      description: 'Accepted',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), message: z.string(), data: exportCsvResponseSchema }) } },
    },
  },
});
