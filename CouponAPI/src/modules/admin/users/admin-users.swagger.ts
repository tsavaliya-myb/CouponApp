import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { 
  adminUsersQuerySchema, 
  awardCoinsSchema,
  baseUserResponseSchema,
  paginatedUsersResponseSchema,
  userDetailsResponseSchema,
  awardCoinsResponseSchema,
} from './admin-users.validator';
import { PAGINATION } from '../../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── ADMIN USERS ENDPOINTS ────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/users',
  summary: 'List Users',
  description: 'Lists all customers with filtering and pagination. Requires Admin Role.',
  tags: ['Admin - Users'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
      cityId: z.string().uuid().optional(),
      areaId: z.string().uuid().optional(),
      status: z.enum(['ACTIVE', 'BLOCKED']).optional(),
      search: z.string().optional().openapi({ description: 'Search by name, phone, or email' }),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: paginatedUsersResponseSchema.shape.data,
            meta: paginatedUsersResponseSchema.shape.meta,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/users/{id}',
  summary: 'Get User Details',
  description: 'Full profile with subscription, redemption, and wallet history. Requires Admin Role.',
  tags: ['Admin - Users'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: userDetailsResponseSchema,
          }),
        },
      },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/users/{id}/block',
  summary: 'Toggle Block Status',
  description: 'Toggles a user between ACTIVE and BLOCKED. Requires Admin Role.',
  tags: ['Admin - Users'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: baseUserResponseSchema,
          }),
        },
      },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/users/{id}/coins',
  summary: 'Manually Award Coins',
  description: 'Credits coins to a user manually and logs a WalletTransaction. Requires Admin Role.',
  tags: ['Admin - Users'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: awardCoinsSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: awardCoinsResponseSchema,
          }),
        },
      },
    },
    400: { description: 'Validation Error', content: { 'application/json': { schema: errorResponse } } },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});
