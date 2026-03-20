import { openApiRegistry } from '../../config/swagger';
import { 
  adminLoginSchema, 
  refreshSchema, 
  logoutSchema,
  adminLoginResponseSchema,
  refreshResponseSchema,
  logoutResponseSchema,
} from './auth.validator';
import { z } from 'zod';

// ─── Reusable Response Schemas ───────────────────────────────────────────────
const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

// ─── Register Auth Endpoints ──────────────────────────────────────────────────
openApiRegistry.registerPath({
  method: 'post',
  path: '/auth/admin/login',
  summary: 'Admin Login',
  description: 'Login for admin users. Returns JWT access token and refresh token.',
  tags: ['Auth'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: adminLoginSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Successful login',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: adminLoginResponseSchema,
          }),
        },
      },
    },
    401: {
      description: 'Invalid credentials',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/auth/refresh',
  summary: 'Refresh Access Token',
  description: 'Exchange a valid refresh token for a new short-lived access token.',
  tags: ['Auth'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: refreshSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'New access token issued',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: refreshResponseSchema,
          }),
        },
      },
    },
    401: {
      description: 'Refresh token invalid or expired',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/auth/logout',
  summary: 'Logout',
  description: 'Invalidates the provided refresh token in Redis.',
  tags: ['Auth'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: logoutSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Successfully logged out',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: logoutResponseSchema,
          }),
        },
      },
    },
  },
});
