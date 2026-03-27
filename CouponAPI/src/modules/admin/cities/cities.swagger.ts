import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import {
  createCitySchema,
  updateCitySchema,
  createAreaSchema,
  updateAreaSchema,
  baseCityResponseSchema,
  cityWithCountsResponseSchema,
  baseAreaResponseSchema,
} from './cities.validator';
import { CityStatus } from '@prisma/client';

// ─── Shared Response Types ────────────────────────────────────────────────────

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
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.array(cityWithCountsResponseSchema),
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
          schema: z.object({ success: z.boolean().default(true), data: baseCityResponseSchema }),
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
          schema: z.object({ success: z.boolean().default(true), data: baseCityResponseSchema }),
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
            data: z.array(baseAreaResponseSchema),
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
          schema: z.object({ success: z.boolean().default(true), data: baseAreaResponseSchema }),
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
          schema: z.object({ success: z.boolean().default(true), data: baseAreaResponseSchema }),
        },
      },
    },
    404: { description: 'Not Found', content: { 'application/json': { schema: errorResponse } } },
  },
});
