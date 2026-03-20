import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { 
  myCouponsQuerySchema, 
  sellerCouponsQuerySchema,
  paginatedUserCouponsResponseSchema,
  paginatedSellerCouponsResponseSchema,
} from './coupons.validator';
import { PAGINATION } from '../../shared/constants';
import { SellerCategory } from '@prisma/client';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── USER COUPONS ENDPOINTS ───────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/coupons',
  summary: 'Get My Active Coupons',
  description: 'Lists instantiated UserCoupons belonging to the authenticated customer that are still active and valid.',
  tags: ['Customer - Coupons'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
      category: z.nativeEnum(SellerCategory).optional(),
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
            data: paginatedUserCouponsResponseSchema.shape.data,
            meta: paginatedUserCouponsResponseSchema.shape.meta,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/coupons/seller/{sellerId}',
  summary: 'Get Master Coupons by Seller',
  description: 'Public/Customer endpoint to view all active coupon deals offered by a specific seller.',
  tags: ['Customer - Coupons'],
  request: {
    params: z.object({ sellerId: z.string().uuid() }),
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
            data: paginatedSellerCouponsResponseSchema.shape.data,
            meta: paginatedSellerCouponsResponseSchema.shape.meta,
          }),
        },
      },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});
