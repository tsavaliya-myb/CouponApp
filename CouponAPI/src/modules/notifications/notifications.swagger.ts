import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { 
  sendNotificationSchema, 
  getHistorySchema,
  sendNotificationResponseSchema,
  paginatedNotificationHistoryResponseSchema,
} from './notifications.validator';

const errorResponse = z.object({ success: z.boolean().default(false), code: z.string(), message: z.string() });

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/notifications/send',
  summary: 'Manual Push Notification Trigger',
  description: 'Dispatches targeted live push notifications out to specific users, cities, or global cohorts instantly constraints using OneSignal API. Requires Admin Role.',
  tags: ['Admin - Notifications'],
  security: [{ bearerAuth: [] }],
  request: { body: { content: { 'application/json': { schema: sendNotificationSchema.shape.body } } } },
  responses: { 
    200: { description: 'Success Delivery Tracking Log', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: sendNotificationResponseSchema }) } } },
    404: { description: 'Target Asset Not Found' },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/notifications/history',
  summary: 'Push Notifications History Log',
  description: 'Yields chronicled dispatch audit log paginated efficiently capturing OneSignal delivery payload keys across time. Requires Admin Role.',
  tags: ['Admin - Notifications'],
  security: [{ bearerAuth: [] }],
  request: { query: getHistorySchema.shape.query },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: paginatedNotificationHistoryResponseSchema.shape.data, meta: paginatedNotificationHistoryResponseSchema.shape.meta }) } } } },
});
