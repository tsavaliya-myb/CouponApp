import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import {
  registerUserSchema,
  updateUserSchema,
  loginUserResponseSchema,
  profileResponseSchema,
  qrTokenResponseSchema,
} from './users.validator';

// schemas imported from validator

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── USER (CUSTOMER) ENDPOINTS ────────────────────────────────────────────────

openApiRegistry.registerPath({
  method: 'post',
  path: '/users/register',
  summary: 'Register / Login User (MVP)',
  description: 'Registers or logs in a user. Bypasses OTP for MVP.',
  tags: ['Customer'],
  request: {
    body: {
      content: { 'application/json': { schema: registerUserSchema } },
    },
  },
  responses: {
    201: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: loginUserResponseSchema,
          }),
        },
      },
    },
    400: { description: 'Bad Request', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/users/me',
  summary: 'Get My Profile',
  tags: ['Customer'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: profileResponseSchema }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'patch',
  path: '/users/me',
  summary: 'Update My Profile',
  tags: ['Customer'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: { 'application/json': { schema: updateUserSchema } },
    },
  },
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: profileResponseSchema }),
        },
      },
    },
    409: { description: 'Email taken', content: { 'application/json': { schema: errorResponse } } },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/users/me/qr',
  summary: 'Generate Redemtion QR',
  description: 'Generates a 5-minute short-lived QR token and a Base64 PNG image string.',
  tags: ['Customer'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: qrTokenResponseSchema,
          }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/users/settings',
  summary: 'Get App Settings',
  description:
    'Returns public app-level configuration values.',
  tags: ['Customer'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.object({
              subscriptionPrice: z.number().describe('Subscription price in INR (e.g. 1000)'),
              bookValidityDays: z.number().describe('Number of days a coupon book remains valid after purchase'),
              maxCoinsPerTransaction: z.number().describe('Maximum coins a user can redeem in a single transaction'),
              totalActiveCoupons: z.number().describe('Live count of all ACTIVE coupons across the system'),
            }),
          }),
        },
      },
    },
    401: { description: 'Unauthorized', content: { 'application/json': { schema: errorResponse } } },
  },
});
