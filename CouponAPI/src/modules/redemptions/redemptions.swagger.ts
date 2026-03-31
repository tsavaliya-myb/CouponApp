import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import {
  confirmRedemptionSchema,
  redemptionHistoryQuerySchema,
  verifyUserResponseSchema,
  confirmRedemptionResponseSchema,
  customerRedemptionHistoryResponseSchema,
  sellerRedemptionHistoryResponseSchema,
} from './redemptions.validator';
import { PAGINATION } from '../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── SELLER REDEMPTION FLOW ───────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/redemptions/verifyUser/{userId}',
  summary: 'Verify Customer',
  description: 'Seller verifies user by userId and gets eligible coupons. Requires Seller Role.',
  tags: ['Seller - Redemptions'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({
      userId: z.string().uuid(),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: verifyUserResponseSchema,
          }),
        },
      },
    },
    400: { description: 'Invalid/Expired QR', content: { 'application/json': { schema: errorResponse } } },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/redemptions/confirm',
  summary: 'Confirm Redemption',
  description: 'Seller confirms the redemption. Applies discount, decrements coupon usage, burns coins, and logs Settlement. Requires Seller Role.',
  tags: ['Seller - Redemptions'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: confirmRedemptionSchema } },
    },
  },
  responses: {
    201: {
      description: 'Created',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: confirmRedemptionResponseSchema,
          }),
        },
      },
    },
    400: { description: 'Validation Constraints trigger (Coin limit, Minimum Spend, Expired)', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/redemptions/seller/history',
  summary: 'Seller Redemption History',
  description: 'Lists redemptions processed by the authenticated seller.',
  tags: ['Seller - Redemptions'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional(),
      limit: z.number().optional(),
      period: z.enum(['this_week', 'this_month', 'all']).optional(),
    }),
  },
  responses: {
    200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: sellerRedemptionHistoryResponseSchema.shape.data, meta: sellerRedemptionHistoryResponseSchema.shape.meta }) } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/redemptions/history',
  summary: 'Customer Redemption History',
  description: 'Lists redemptions performed by the authenticated customer.',
  tags: ['Customer - Redemptions'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional(),
      limit: z.number().optional(),
      period: z.enum(['this_week', 'this_month', 'all']).optional(),
    }),
  },
  responses: {
    200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: customerRedemptionHistoryResponseSchema.shape.data, meta: customerRedemptionHistoryResponseSchema.shape.meta }) } } },
  },
});
