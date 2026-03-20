import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';

openApiRegistry.registerPath({
  method: 'get',
  path: '/sellers/me/dashboard',
  summary: 'Seller localized Performance Dashboard',
  description: "Fetches today's footfall metrics alongside real-time transparent Settlement arrays covering owed commissions vs receivables. Requires Seller Role.",
  tags: ['Sellers - Dashboard'],
  security: [{ bearerAuth: [] }],
  responses: { 200: { description: 'Seller Context Map Data', content: { 'application/json': { schema: z.any() } } } },
});
