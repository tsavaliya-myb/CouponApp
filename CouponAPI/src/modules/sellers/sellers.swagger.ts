import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { SellerCategory } from '@prisma/client';
import {
  registerSellerSchema,
  updateSellerSchema,
  findSellersSchema,
} from './sellers.validator';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── Shared Response Schemas ──────────────────────────────────────────────────
const baseSellerResponse = z.object({
  id: z.string().uuid(),
  phone: z.string(),
  businessName: z.string(),
  category: z.nativeEnum(SellerCategory),
  cityId: z.string().uuid(),
  areaId: z.string().uuid(),
  status: z.enum(['PENDING', 'ACTIVE', 'SUSPENDED']),
});

const profileResponse = baseSellerResponse.extend({
  city: z.object({ id: z.string(), name: z.string() }).nullable(),
  area: z.object({ id: z.string(), name: z.string() }).nullable(),
});

const distanceSellerResponse = z.object({
  id: z.string().uuid(),
  businessName: z.string(),
  category: z.nativeEnum(SellerCategory),
  area: z.string().nullable(),
  lat: z.number().nullable(),
  lng: z.number().nullable(),
  distanceKm: z.number().nullable(),
});

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
            data: z.object({
              accessToken: z.string(),
              refreshToken: z.string(),
              seller: baseSellerResponse,
              message: z.string(),
            }),
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
          schema: z.object({ success: z.boolean().default(true), data: profileResponse }),
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
          schema: z.object({ success: z.boolean().default(true), data: profileResponse }),
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
            data: z.object({
              totalRedemptions: z.number(),
              status: z.enum(['PENDING', 'ACTIVE', 'SUSPENDED']),
              commissionPct: z.number(),
            }),
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
            data: z.array(distanceSellerResponse),
          }),
        },
      },
    },
  },
});
