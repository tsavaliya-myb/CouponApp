import { openApiRegistry } from '../../config/swagger';
import { z } from 'zod';
import { 
  analyticsSubscriptionsSchema, 
  analyticsRedemptionsSchema, 
  analyticsGenericLimitSchema,
  subscriptionStatsResponseSchema,
  redemptionStatsResponseSchema,
  topSellerStatsResponseSchema,
  topCouponStatsResponseSchema,
  coinStatsResponseSchema,
  churnStatsResponseSchema,
  revenueStatsResponseSchema,
  redemptionByCategoryResponseSchema,
  dateRangeSchema,
  analyticsRevenueSchema,
} from './analytics.validator';

const errorResponse = z.object({ success: z.boolean().default(false), code: z.string(), message: z.string() });

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/subscriptions',
  summary: 'Subscriptions Revenue Report',
  description: 'Aggregates subscription volume and raw revenue generated chronologically. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  request: { query: analyticsSubscriptionsSchema },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: subscriptionStatsResponseSchema }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/redemptions',
  summary: 'Total Dispersed Redemptions Report',
  description: 'Counts the complete usage behavior across specific filter variables (date bounds, Category, City, specific Seller). Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  request: { query: analyticsRedemptionsSchema },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: redemptionStatsResponseSchema }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/sellers/top',
  summary: 'Top Performing Sellers',
  description: 'Yields the top-tier sellers filtered by highest grossing redemptions. Operates iteratively downwards. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  request: { query: analyticsGenericLimitSchema },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: z.array(topSellerStatsResponseSchema) }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/coupons/top',
  summary: 'Most Activated Top Coupons',
  description: 'Tracks the most utilized `UserCoupons` mapping exact engagement performance. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  request: { query: analyticsGenericLimitSchema },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: z.array(topCouponStatsResponseSchema) }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/coins',
  summary: 'Coin Economy Overview',
  description: 'Global liability vs usage tracking report comparing completely minted coins vs totally burnt transactional coins. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: coinStatsResponseSchema }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/churn',
  summary: 'Subscriber Global Churn Overview',
  description: 'Analyzes the ratio between natively active current subscribers vs completely expired un-renewed accounts globally. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: churnStatsResponseSchema }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/revenue',
  summary: 'Admin Revenue Report',
  description: 'Calculates the subscription revenue and commission revenue grouped by day, week, or year. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  request: { query: analyticsRevenueSchema },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: revenueStatsResponseSchema }) } } } },
});

openApiRegistry.registerPath({
  method: 'get',
  path: '/admin/analytics/redemptions/category',
  summary: 'Redemptions by Category',
  description: 'Aggregates the total number of coupon redemptions grouped by seller category. Requires Admin Role.',
  tags: ['Admin - Analytics'],
  security: [{ bearerAuth: [] }],
  request: { query: dateRangeSchema },
  responses: { 200: { description: 'Success', content: { 'application/json': { schema: z.object({ success: z.boolean().default(true), data: redemptionByCategoryResponseSchema }) } } } },
});
