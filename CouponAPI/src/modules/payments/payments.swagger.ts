import { openApiRegistry } from '../../config/swagger';
import { createOrderResponseSchema } from './payments.validator';
import { z } from 'zod';

const errorResponse = z.object({
  success: z.boolean().default(false),
  code: z.string(),
  message: z.string(),
});

openApiRegistry.registerPath({
  method: 'post',
  path: '/payments/create-order',
  summary: 'Create Razorpay Order',
  description: 'Creates a Razorpay payment order for subscription purchase. Price is read from AppSetting `subscription_price`.',
  tags: ['Payments'],
  security: [{ bearerAuth: [] }],
  responses: {
    201: {
      description: 'Order created successfully',
      content: {
        'application/json': {
          schema: z.object({
            success: z.boolean().default(true),
            data: createOrderResponseSchema,
          }),
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

openApiRegistry.registerPath({
  method: 'post',
  path: '/payments/webhook',
  summary: 'Razorpay Webhook',
  description: 'Webhook endpoint for Razorpay events. Protected by HMAC signature. On `payment.captured`, creates Subscription, CouponBook, UserCoupons and awards coins.',
  tags: ['Payments'],
  request: {
    headers: z.object({
      'x-razorpay-signature': z.string(),
    }),
  },
  responses: {
    200: {
      description: 'Webhook acknowledged',
      content: {
        'application/json': {
          schema: z.object({ status: z.literal('ok') }),
        },
      },
    },
    400: {
      description: 'Invalid or missing signature',
      content: { 'application/json': { schema: errorResponse } },
    },
  },
});
