import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import {
  registerInfluencerSchema,
  updateInfluencerSchema,
  findInfluencersSchema,
  createServiceSchema,
  updateServiceSchema,
  createBookingSchema,
  updateBookingStatusSchema
} from './influencers.validator';
import { extendZodWithOpenApi } from '@asteasolutions/zod-to-openapi';

extendZodWithOpenApi(z);

const successResponse = {
  description: 'Successful response',
  content: { 'application/json': { schema: z.object({ success: z.boolean(), data: z.any() }) } },
};

openApiRegistry.registerPath({
  method: 'post',
  path: '/influencers/register',
  tags: ['Influencers'],
  summary: 'Register a new influencer',
  request: { body: { content: { 'application/json': { schema: registerInfluencerSchema } } } },
  responses: { 201: successResponse },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/influencers',
  tags: ['Influencers'],
  summary: 'Find influencers (customer view)',
  security: [{ bearerAuth: [] }],
  request: { query: findInfluencersSchema },
  responses: { 200: successResponse },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/influencers/niches',
  tags: ['Influencers'],
  summary: 'Get active influencer niches',
  security: [{ bearerAuth: [] }],
  responses: { 200: successResponse },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/influencers/{id}',
  tags: ['Influencers'],
  summary: 'Get influencer public profile',
  security: [{ bearerAuth: [] }],
  request: { params: z.object({ id: z.string().uuid() }) },
  responses: { 200: successResponse },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/influencers/book',
  tags: ['Influencers'],
  summary: 'Book an influencer service (customer)',
  security: [{ bearerAuth: [] }],
  request: { body: { content: { 'application/json': { schema: createBookingSchema } } } },
  responses: { 201: successResponse },
});

// Add remaining routes documentation as needed...
