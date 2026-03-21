import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { updateSettingsSchema, appSettingsResponseSchema } from './settings.validator';

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/settings',
  summary: 'Retrieve global platform configurations',
  description: 'Fetches the full dynamic key-value map configuring constraints globally across the App. Requires Admin Role.',
  tags: ['Admin - Settings'],
  security: [{ bearerAuth: [] }],
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: appSettingsResponseSchema }) } } } },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/settings',
  summary: 'Upsert global platform configurations',
  description: 'Mutates global platform key-values seamlessly. Overwrites existing keys or builds them dynamically if entirely new. Requires Admin Role.',
  tags: ['Admin - Settings'],
  security: [{ bearerAuth: [] }],
  request: { body: { content: { 'application/json': { schema: updateSettingsSchema } } } },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: appSettingsResponseSchema }) } } } },
});
