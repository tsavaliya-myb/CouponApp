import { openApiRegistry } from '../../config/swagger';
import { 
  adminLoginSchema, 
  refreshSchema, 
  logoutSchema,
  sendOtpSchema,
  verifyOtpSchema,
  adminLoginResponseSchema,
  refreshResponseSchema,
  logoutResponseSchema,
  sendOtpResponseSchema,
  verifyOtpResponseSchema,
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
  path: '/auth/send-otp',
  summary: 'Send OTP',
  description: 'Send a 6-digit OTP to a mobile number for login/registration.',
  tags: ['Auth'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: sendOtpSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'OTP sent successfully',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: sendOtpResponseSchema,
          }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/auth/verify-otp',
  summary: 'Verify OTP',
  description: 'Verify phone number and OTP to login or register a user.',
  tags: ['Auth'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: verifyOtpSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Successfully verified and logged in',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: verifyOtpResponseSchema,
          }),
        },
      },
    },
    401: {
      description: 'Invalid or expired OTP',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/auth/seller/send-otp',
  summary: 'Send Seller OTP',
  description: 'Send a 6-digit OTP to a seller mobile number.',
  tags: ['Auth', 'Sellers'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: sendOtpSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'OTP sent successfully',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: sendOtpResponseSchema,
          }),
        },
      },
    },
  },
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/auth/seller/verify-otp',
  summary: 'Verify Seller OTP',
  description: 'Verify phone number and OTP for seller. Returns registrationToken if new, or access tokens if exists.',
  tags: ['Auth', 'Sellers'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: verifyOtpSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Successfully verified',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.any().openapi({ description: 'sellerVerifyOtpResponseSchema' }),
          }),
        },
      },
    },
    401: {
      description: 'Invalid or expired OTP',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

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
