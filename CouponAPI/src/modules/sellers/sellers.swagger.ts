import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { SellerCategory } from '@prisma/client';
import {
  registerSellerSchema,
  updateSellerSchema,
  findSellersSchema,
  getSellersByAreaCategorySchema,
  loginSellerResponseSchema,
  profileResponseSchema,
  sellerDashboardResponseSchema,
  distanceSellerResponseSchema,
} from './sellers.validator';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// Schemas are imported from validator

// ─── SELLER ENDPOINTS ─────────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'post',
  path: '/sellers/register',
  summary: 'Register / Login Seller (MVP)',
  description: 'Registers or logs in a seller. Bypasses OTP for MVP.',
  tags: ['Sellers'],
  request: {
    body: {
      content: { 'application/json': { schema: registerSellerSchema } },
    },
  },
  responses: {
    201: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: loginSellerResponseSchema,
          }),
        },
      },
    },
    400: { description: 'Bad Request', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/sellers/me',
  summary: 'Get Seller Profile',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: profileResponseSchema }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/sellers/me',
  summary: 'Update Seller Profile',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: updateSellerSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: profileResponseSchema }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/sellers/me/dashboard',
  summary: 'Seller Dashboard Overview',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: sellerDashboardResponseSchema,
          }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/sellers',
  summary: 'Find Sellers Near Me',
  description: 'Customer view. Lists active sellers sorted by distance (Haversine formula).',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      lat: z.coerce.number().openapi({ description: 'User latitude' }),
      lng: z.coerce.number().openapi({ description: 'User longitude' }),
      cityId: z.string().uuid().optional(),
      limit: z.coerce.number().default(20),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(distanceSellerResponseSchema),
          }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/sellers/by-area-category',
  summary: 'Find Sellers by Area and Category',
  description: 'Customer view. Lists active sellers filtered by area and category.',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      areaId: z.string().uuid().openapi({ description: 'Area ID' }),
      categoryType: z.nativeEnum(SellerCategory).optional().openapi({ description: 'Seller Category' }),
      page: z.coerce.number().default(1),
      limit: z.coerce.number().default(20),
    }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(distanceSellerResponseSchema),
            meta: z.object({
              total: z.number(),
              page: z.number(),
              limit: z.number(),
              totalPages: z.number(),
            }).optional(),
          }),
        },
      },
    },
  },
});
