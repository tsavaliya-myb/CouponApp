import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { registerUserSchema, updateUserSchema } from './users.validator';

// ─── Shared Response Schemas ──────────────────────────────────────────────────
const baseUserResponse = z.object({
  id: z.string().uuid(),
  phone: z.string(),
  name: z.string(),
  email: z.string().nullable(),
  cityId: z.string().uuid().nullable(),
  areaId: z.string().uuid().nullable(),
  status: z.enum(['ACTIVE', 'BLOCKED']),
});

const profileResponse = baseUserResponse.extend({
  city: z.object({ id: z.string(), name: z.string() }).nullable(),
  area: z.object({ id: z.string(), name: z.string() }).nullable(),
});

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
  tags: ['Users (Customer)'],
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
            data: z.object({
              accessToken: z.string(),
              refreshToken: z.string(),
              user: baseUserResponse,
            }),
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
  tags: ['Users (Customer)'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: profileResponse }),
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
  tags: ['Users (Customer)'],
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
          schema: z.object({ success: z.boolean().default(true), data: profileResponse }),
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
  tags: ['Users (Customer)'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Success',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.object({
              qrToken: z.string(),
              qrImageBase64: z.string(),
              expiresInSeconds: z.number(),
            }),
          }),
        },
      },
    },
  },
});
