import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { 
  settlementsQuerySchema,
  paginatedSettlementsSchema,
  settlementDetailSchema,
} from './settlements.validator';
import { PAGINATION } from '../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── SELLER SETTLEMENTS ───────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/settlements',
  summary: 'My Weekly Settlements',
  description: 'Lists the chronological weekly settlement snapshots mapping how much commission the Seller owes Admin, and how much Coin compensation Admin owes Seller. Requires Seller Role.',
  tags: ['Seller - Settlements'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: paginatedSettlementsSchema.shape.data,
            meta: paginatedSettlementsSchema.shape.meta,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/settlements/week/{weekId}/summary',
  summary: 'Weekly Settlement Breakdown',
  description: 'Fetches the detailed line items attached to a specific Settlement UUID containing exact Redemption logs. Requires Seller Role.',
  tags: ['Seller - Settlements'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ weekId: z.string().uuid() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: settlementDetailSchema }) } },
    },
    404: { description: 'Settlement Not Found', content: { 'application/json': { schema: errorResponse } } },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});
