import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { adminCouponsQuerySchema, createCouponSchema, updateCouponSchema, syncBaseCouponsSchema } from './admin-coupons.validator';
import { PAGINATION } from '../../../shared/constants';
import { CouponType } from '@prisma/client';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── ADMIN COUPONS CRUD ───────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/coupons',
  summary: 'List Master Coupons',
  description: 'Lists all coupon templates across the platform with filtering. Requires Admin Role.',
  tags: ['Admin - Coupons'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      page: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_PAGE}` }),
      limit: z.number().optional().openapi({ description: `Default: ${PAGINATION.DEFAULT_LIMIT}` }),
      sellerId: z.string().uuid().optional(),
      cityId: z.string().uuid().optional(),
      type: z.nativeEnum(CouponType).optional(),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(z.any()),
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
  method: 'post',
  path: '/admin/coupons',
  summary: 'Create Coupon',
  description: 'Creates a master coupon for a specific seller. Requires Admin Role.',
  tags: ['Admin - Coupons'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: createCouponSchema } },
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
    400: { description: 'Validation Error', content: { 'application/json': { schema: errorResponse } } },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/coupons/{id}',
  summary: 'Update Coupon',
  description: 'Update discount, usage limits, or type of a master coupon. Requires Admin Role.',
  tags: ['Admin - Coupons'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: updateCouponSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.any() }) } },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/coupons/{id}/deactivate',
  summary: 'Deactivate Coupon',
  description: 'Soft deletes a coupon by setting status to INACTIVE. Requires Admin Role.',
  tags: ['Admin - Coupons'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.any() }) } },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

// ─── ADMIN CITY BASE COUPONS ──────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/cities/{cityId}/base-coupons',
  summary: 'Get City Base Coupons',
  description: 'Lists all base coupons automatically assigned to users in this city. Requires Admin Role.',
  tags: ['Admin - Coupons', 'Admin - Cities'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ cityId: z.string().uuid() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.array(z.any()) }) } },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/cities/{cityId}/base-coupons',
  summary: 'Sync City Base Coupons',
  description: 'Replaces the entire base coupon set for a city. Requires Admin Role.',
  tags: ['Admin - Coupons', 'Admin - Cities'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ cityId: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: syncBaseCouponsSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.array(z.any()) }) } },
    },
    400: { description: 'Validation or Alien Coupon Error', content: { 'application/json': { schema: errorResponse } } },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});
