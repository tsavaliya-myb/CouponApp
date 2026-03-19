import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { adminSellersQuerySchema, adminUpdateSellerSchema } from './admin-sellers.validator';
import { PAGINATION } from '../../../shared/constants';
import { SellerCategory } from '@prisma/client';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/sellers',
  summary: 'List Sellers',
  description: 'Lists all sellers with filtering. Requires Admin Role.',
  tags: ['Admin - Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
      cityId: z.string().uuid().optional(),
      areaId: z.string().uuid().optional(),
      category: z.nativeEnum(SellerCategory).optional(),
      status: z.enum(['PENDING', 'ACTIVE', 'SUSPENDED']).optional(),
      search: z.string().optional(),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(z.any()), // array of sellers
            meta: z.object({
              total: z.number(),
              page: z.number(),
              limit: z.number(),
              totalPages: z.number(),
            }),
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/sellers/{id}/approve',
  summary: 'Approve Seller',
  description: 'Changes a seller status from PENDING to ACTIVE. Requires Admin Role.',
  tags: ['Admin - Sellers'],
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
            data: z.object({ id: z.string(), status: z.string() }),
          }),
        },
      },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/sellers/{id}/suspend',
  summary: 'Suspend Seller',
  description: 'Changes a seller status to SUSPENDED. Requires Admin Role.',
  tags: ['Admin - Sellers'],
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
            data: z.object({ id: z.string(), status: z.string() }),
          }),
        },
      },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/sellers/{id}',
  summary: 'Edit Seller Details',
  description: 'Manually edit seller details, including commissionPct. Requires Admin Role.',
  tags: ['Admin - Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: adminUpdateSellerSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.any(),
          }),
        },
      },
    },
    400: { description: 'Validation Error', content: { 'application/json': { schema: errorResponse } } },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});
