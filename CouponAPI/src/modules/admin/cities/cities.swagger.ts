import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import {
  createCitySchema,
  updateCitySchema,
  createAreaSchema,
  updateAreaSchema,
} from './cities.validator';
import { CityStatus } from '@prisma/client';

// ─── Shared Response Types ────────────────────────────────────────────────────

const baseCityResponse = z.object({
  id: z.string().uuid(),
  name: z.string(),
  status: z.nativeEnum(CityStatus),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

const cityWithCountsResponse = baseCityResponse.extend({
  _count: z.object({
    areas: z.number(),
    users: z.number(),
    sellers: z.number(),
  }),
});

const baseAreaResponse = z.object({
  id: z.string().uuid(),
  name: z.string(),
  cityId: z.string().uuid(),
  isActive: z.boolean(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── CITIES ───────────────────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/cities',
  summary: 'List Cities',
  description: 'Returns all cities with counts of areas, users, and sellers. Requires Admin role.',
  tags: ['Admin - Cities & Areas'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(cityWithCountsResponse),
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
    403: { description: 'Forbidden', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/cities',
  summary: 'Create City',
  tags: ['Admin - Cities & Areas'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: createCitySchema } },
    },
  },
  responses: {
    201: {
      description: 'Created',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: baseCityResponse }),
        },
      },
    },
    400: { description: 'Validation Error', content: { 'application/json': { schema: errorResponse } } },
    409: { description: 'Conflict (Duplicate Name)', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/cities/{id}',
  summary: 'Update City',
  tags: ['Admin - Cities & Areas'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: updateCitySchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: baseCityResponse }),
        },
      },
    },
    404: { description: 'Not Found', content: { 'application/json': { schema: errorResponse } } },
  },
});

// ─── AREAS ────────────────────────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/cities/{cityId}/areas',
  summary: 'List Areas by City',
  tags: ['Admin - Cities & Areas'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ cityId: z.string().uuid() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(baseAreaResponse),
          }),
        },
      },
    },
    404: { description: 'City Not Found', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/cities/{cityId}/areas',
  summary: 'Create Area',
  tags: ['Admin - Cities & Areas'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ cityId: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: createAreaSchema } },
    },
  },
  responses: {
    201: {
      description: 'Created',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: baseAreaResponse }),
        },
      },
    },
    409: { description: 'Conflict (Duplicate Area in City)', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/areas/{id}',
  summary: 'Update Area',
  tags: ['Admin - Cities & Areas'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: {
      content: { 'application/json': { schema: updateAreaSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: baseAreaResponse }),
        },
      },
    },
    404: { description: 'Not Found', content: { 'application/json': { schema: errorResponse } } },
  },
});
