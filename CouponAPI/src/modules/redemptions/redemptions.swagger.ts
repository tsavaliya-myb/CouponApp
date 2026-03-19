import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { scanQrSchema, confirmRedemptionSchema, redemptionHistoryQuerySchema } from './redemptions.validator';
import { PAGINATION } from '../../shared/constants';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── SELLER REDEMPTION FLOW ───────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'post',
  path: '/redemptions/scan',
  summary: 'Scan Customer QR',
  description: 'Seller scans the short-lived user QR token. Validates JWT and returns customer details along with active eligible coupons at this seller. Requires Seller Role.',
  tags: ['Redemptions (Seller)'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: scanQrSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.object({
              user: z.any(),
              eligibleCoupons: z.array(z.any()),
            }),
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
  tags: ['Redemptions (Seller)'],
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
            data: z.any(),
          }),
        },
      },
    },
    400: { description: 'Validation Constraints trigger (Coin limit, Minimum Spend, Expired)', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/sellers/me/redemptions',
  summary: 'Seller Redemption History',
  description: 'Lists redemptions processed by the authenticated seller.',
  tags: ['Redemptions (Seller)'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional(),
      limit: z.number().optional(),
      period: z.enum(['this_week', 'this_month', 'all']).optional(),
    }),
  },
  responses: {
    200: { description: 'Success', content: { 'application/json': { schema: z.any() } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/redemptions/history',
  summary: 'Customer Redemption History',
  description: 'Lists redemptions performed by the authenticated customer.',
  tags: ['Redemptions (Customer)'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional(),
      limit: z.number().optional(),
      period: z.enum(['this_week', 'this_month', 'all']).optional(),
    }),
  },
  responses: {
    200: { description: 'Success', content: { 'application/json': { schema: z.any() } } },
  },
});
