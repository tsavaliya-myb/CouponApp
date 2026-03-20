import { openApiRegistry } from '../../../config/swagger';
import { z } from 'zod';
import { 
  updateWalletSettingsSchema, 
  bulkAwardCoinsSchema,
  walletSettingsResponseSchema,
  walletOverviewResponseSchema,
  bulkAwardResponseSchema,
} from './admin-wallet.validator';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── ADMIN WALLET MANAGEMENT ──────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/wallet/settings',
  summary: 'Get Wallet Settings',
  description: 'Retrieves global platform configurations for Wallet Coins (AppSetting constants). Requires Admin Role.',
  tags: ['Admin - Wallet'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: walletSettingsResponseSchema,
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/admin/wallet/settings',
  summary: 'Update Wallet Settings',
  description: 'Mutates global platform configurations for Wallet Coins asynchronously. Requires Admin Role.',
  tags: ['Admin - Wallet'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: updateWalletSettingsSchema } },
    },
  },
  responses: {
    200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: walletSettingsResponseSchema }) } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/wallet/overview',
  summary: 'Platform Liability Overview',
  description: 'Calculates the real-time exact coin compensation owed globally minus all usages. Requires Admin Role.',
  tags: ['Admin - Wallet'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: walletOverviewResponseSchema,
          }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/admin/wallet/bulk-award',
  summary: 'Bulk Award Coins',
  description: 'Mints new coins immediately to all registered customers matching the criteria (i.e. by specific City). Requires Admin Role.',
  tags: ['Admin - Wallet'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: bulkAwardCoinsSchema } },
    },
  },
  responses: {
    200: {
      description: 'Successfully awarded multiple users at once',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: bulkAwardResponseSchema,
          }),
        },
      },
    },
  },
});
