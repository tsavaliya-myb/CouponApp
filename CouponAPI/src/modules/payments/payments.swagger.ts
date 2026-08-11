import { openApiRegistry } from '../../config/swagger';
import {
  initiatePaymentResponseSchema,
  verifyPaymentRequestSchema,
  verifyPaymentResponseSchema,
} from './payments.validator';
import { z } from 'zod';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code:    z.string(),
  message: z.string(),
});

// POST /payments/initiate
openApiRegistry.registerPath({
  method:  'post',
  path:    '/payments/initiate',
  summary: 'Initiate Razorpay UPI Autopay mandate',
  description:
    'Creates a Razorpay order carrying UPI Autopay token params (max_amount, expire_at, frequency) and ' +
    'returns Checkout options for the Flutter SDK. Price is read from AppSetting `subscription_price`. ' +
    'A PENDING PaymentAttempt row is created on every call.',
  tags:     ['Payments'],
  security: [{ bearerAuth: [] }],
  responses: {
    201: {
      description: 'Checkout params ready',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: initiatePaymentResponseSchema }),
        },
      },
    },
    401: {
      description: 'Unauthorized',
      content: { 'application/json': { schema: errorResponse } },
    },
    409: {
      description: 'User already has an active subscription, or price exceeds the mandate max_amount',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

// POST /payments/verify
openApiRegistry.registerPath({
  method:  'post',
  path:    '/payments/verify',
  summary: 'Verify a Razorpay Checkout success callback',
  description:
    'Called by the Flutter app immediately after Checkout reports success. Verifies the HMAC-SHA256 ' +
    'signature and optimistically fulfils the subscription if the payment is already captured, so the ' +
    'user does not have to wait on the webhook. The webhook remains the source of truth and is idempotent ' +
    'against this call.',
  tags:     ['Payments'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: {
        'application/json': { schema: verifyPaymentRequestSchema },
      },
    },
  },
  responses: {
    200: {
      description: 'Verified',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: verifyPaymentResponseSchema }),
        },
      },
    },
    400: {
      description: 'Missing required fields',
      content: { 'application/json': { schema: errorResponse } },
    },
    401: {
      description: 'Unauthorized',
      content: { 'application/json': { schema: errorResponse } },
    },
    409: {
      description: 'Signature mismatch or payment/order record not found',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

// POST /payments/webhook
openApiRegistry.registerPath({
  method:  'post',
  path:    '/payments/webhook',
  summary: 'Razorpay webhook',
  description:
    'Receives Razorpay webhook events (`application/json`, signed via `X-Razorpay-Signature`). ' +
    'Responds 200 immediately and processes async. Handles `payment.captured` (fulfils a MANDATE or ' +
    'extends a RENEWAL), `payment.failed` (records failure, bumps renewalFailureCount, expires after 3), ' +
    '`token.confirmed` (mandate live), and `token.cancelled` / `token.paused` / `token.rejected` ' +
    '(disables autopay). Idempotent — deduped on a hash of the raw request body.',
  tags: ['Payments'],
  request: {
    body: {
      content: {
        'application/json': {
          schema: z.object({
            event:   z.string(),
            payload: z.record(z.string(), z.any()),
          }).passthrough(),
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Webhook acknowledged (processing continues async)',
      content: {
        'application/json': {
          schema: z.object({ status: z.literal('ok') }),
        },
      },
    },
  },
});

// POST /payments/cancel-autopay
openApiRegistry.registerPath({
  method:  'post',
  path:    '/payments/cancel-autopay',
  summary: 'Cancel UPI Autopay',
  description:
    'Deletes the Razorpay mandate token (`customers.deleteToken`) and disables autopay locally so the ' +
    'renewal job skips this user, even if the remote call fails.',
  tags:     ['Payments'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Autopay cancelled',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: z.object({ message: z.string() }) }),
        },
      },
    },
    409: {
      description: 'No subscription, or autopay already disabled',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

// GET /payments/history
openApiRegistry.registerPath({
  method:  'get',
  path:    '/payments/history',
  summary: 'Fetch payment history and current subscription',
  tags:     ['Payments'],
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Subscription details and successful payment attempts',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: z.object({
              subscription: z.object({
                status: z.string(),
                startDate: z.string(),
                endDate: z.string(),
                isAutopayEnabled: z.boolean(),
              }).nullable(),
              history: z.array(z.object({
                id: z.string(),
                razorpayOrderId: z.string(),
                amount: z.string(),
                createdAt: z.string(),
                kind: z.string(),
              })),
            }),
          }),
        },
      },
    },
    401: {
      description: 'Unauthorized',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});
