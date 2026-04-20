import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import {
  registerSellerSchema,
  updateSellerSchema,
  findSellersSchema,
  getSellersByCityCategorySchema,
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
  summary: 'Register Seller Profile',
  description: 'Registers a seller. Requires a valid registrationToken in the Authorization header (obtained via /auth/seller/verify-otp).',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
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
  method: 'post',
  path: '/sellers/me/logo',
  summary: 'Upload Seller Logo',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: {
        'multipart/form-data': {
          schema: z.object({
            logo: z.any().openapi({ type: 'string', format: 'binary' }),
          }),
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.any() }) } },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/sellers/me/media',
  summary: 'Upload Seller Media (Photos & Video)',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: {
        'multipart/form-data': {
          schema: z.object({
            photo1: z.any().optional().openapi({ type: 'string', format: 'binary' }),
            photo2: z.any().optional().openapi({ type: 'string', format: 'binary' }),
            video: z.any().optional().openapi({ type: 'string', format: 'binary' }),
          }),
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.any() }) } },
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
  path: '/sellers/by-city-category',
  summary: 'Find Sellers by City and Category',
  description: 'Customer view. Lists active sellers filtered by city (required) and optionally by category.',
  tags: ['Sellers'],
  security: [{ bearerAuth: [] }],
  request: {
    query: z.object({
      cityId: z.string().uuid().openapi({ description: 'City ID (required)' }),
      categoryId: z.string().uuid().optional().openapi({ description: 'Category ID to filter by (optional — omit for all sellers in city)' }),
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
