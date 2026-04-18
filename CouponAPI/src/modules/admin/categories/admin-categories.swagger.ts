import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { createCategorySchema, updateCategorySchema, categoryResponseSchema } from './admin-categories.validator';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/categories',
  summary: 'List Categories',
  description: 'Returns all active categories. Pass includeInactive=true (admin only) to include inactive ones.',
  tags: ['Categories'],
  request: {
    query: z.object({ includeInactive: z.boolean().optional() }),
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: z.array(categoryResponseSchema) }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/categories',
  summary: 'Create Category',
  description: 'Creates a new seller category. Requires Admin Role.',
  tags: ['Admin - Categories'],
  security: [{ bearerAuth: [] }],
  request: {
    body: { content: { 'application/json': { schema: createCategorySchema } } },
  },
  responses: {
    201: {
      description: 'Created',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: categoryResponseSchema }),
        },
      },
    },
    409: { description: 'Conflict', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/categories/{id}',
  summary: 'Update Category',
  description: 'Updates a category name, slug, icon, or active status. Requires Admin Role.',
  tags: ['Admin - Categories'],
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ id: z.string().uuid() }),
    body: { content: { 'application/json': { schema: updateCategorySchema } } },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: categoryResponseSchema }),
        },
      },
    },
    404: { description: 'Not found', content: { 'application/json': { schema: errorResponse } } },
  },
});
