import { openApiRegistry } from '../../config/swagger';
import { initiatePaymentResponseSchema, generateHashResponseSchema } from './payments.validator';
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
  summary: 'Initiate PayU UPI Autopay',
  description:
    'Returns PayU payment params for the Flutter CheckoutPro SDK to open a UPI Autopay mandate-registration screen. ' +
    'Price is read from AppSetting `subscription_price`. A PENDING PaymentAttempt row is created on every call.',
  tags:     ['Payments'],
  security: [{ bearerAuth: [] }],
  responses: {
    201: {
      description: 'Payment params ready',
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
      description: 'User already has an active subscription',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

// POST /payments/generate-hash
openApiRegistry.registerPath({
  method:  'post',
  path:    '/payments/generate-hash',
  summary: 'Generate PayU hash (SDK callback)',
  description:
    'Called by the Flutter SDK\'s `generateHash` callback. Accepts the raw `hashString` supplied by the SDK ' +
    'and returns `SHA512(hashString + SALT)`. The merchant salt never leaves the server.',
  tags:     ['Payments'],
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      content: {
        'application/json': {
          schema: z.object({ hash_string: z.string().min(1) }),
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Hash computed',
      content: {
        'application/json': {
          schema: z.object({ success: z.boolean().default(true), data: generateHashResponseSchema }),
        },
      },
    },
    400: {
      description: 'hash_string missing or empty',
      content: { 'application/json': { schema: errorResponse } },
    },
    401: {
      description: 'Unauthorized',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});

// POST /payments/webhook
openApiRegistry.registerPath({
  method:  'post',
  path:    '/payments/webhook',
  summary: 'PayU S2S webhook',
  description:
    'Receives PayU server-to-server payment notifications (`application/x-www-form-urlencoded`). ' +
    'Responds 200 immediately and processes async. Verifies the reverse SHA-512 hash (SI-aware). ' +
    'On `status=success`: fulfils subscription, creates CouponBook, awards coins, updates PaymentAttempt to SUCCESS. ' +
    'On any other status: updates PaymentAttempt to FAILED with error details. ' +
    'Idempotent — duplicate webhooks keyed on `mihpayid` are silently ignored.',
  tags: ['Payments'],
  request: {
    body: {
      content: {
        'application/x-www-form-urlencoded': {
          schema: z.object({
            txnid:         z.string(),
            mihpayid:      z.string(),
            status:        z.enum(['success', 'failure', 'pending', 'usercancelled']),
            hash:          z.string().describe('Reverse SHA-512 hash for verification'),
            si_details:    z.string().optional().describe('JSON string of SI mandate params'),
            auth_payuid:   z.string().optional().describe('Mandate reference for recurring debits'),
            authPayUID:    z.string().optional().describe('Alternate key for mandate reference'),
            error_Message: z.string().optional(),
            error_code:    z.string().optional(),
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
