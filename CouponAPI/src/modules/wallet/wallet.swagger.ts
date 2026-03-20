import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { 
  walletHistoryQuerySchema,
  walletHistoryResponseSchema,
} from './wallet.validator';
import { PAGINATION } from '../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── USER WALLET ENDPOINT ─────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/wallet',
  summary: 'Get Wallet Balance and History',
  description: 'Calculates user available coin balance dynamically and lists chronological transaction history (Redemptions, Bulk awards, Subscription earnings). Requires Customer Role.',
  tags: ['Customer - Wallet'],
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
            data: walletHistoryResponseSchema,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});
