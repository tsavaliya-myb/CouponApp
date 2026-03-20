import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { adminDashboardStatsResponseSchema } from './dashboard.validator';

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/dashboard',
  summary: 'Admin Global Dashboard Metrics',
  description: 'Aggregates broad platform telemetry covering redemptions, pending sellers, trailing revenue, and coin issuance. Requires Admin Role.',
  tags: ['Admin - Dashboard'],
  security: [{ bearerAuth: [] }],
  responses: { 200: { description: 'Success Stats Object', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: adminDashboardStatsResponseSchema }) } } } },
});
