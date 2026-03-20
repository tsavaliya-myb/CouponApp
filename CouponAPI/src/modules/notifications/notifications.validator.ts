import { z } from 'zod';

export const sendNotificationSchema = z.object({
  body: z.object({
    targetType: z.enum(['USER', 'CITY', 'GLOBAL']),
    targetId: z.string().uuid().optional(),
    title: z.string().min(3),
    body: z.string().min(5),
  }).refine((data) => {
    // If target type is USER or CITY, targetId MUST exist
    if (data.targetType !== 'GLOBAL' && !data.targetId) return false;
    return true;
  }, {
    message: "targetId must be explicitly defined when dispatching to USER or CITY targets.",
    path: ['targetId']
  }),
});

export const getHistorySchema = z.object({
  query: z.object({
    page: z.coerce.number().min(1).default(1),
    limit: z.coerce.number().min(1).max(100).default(20),
  }),
});

export type SendNotificationBody = z.infer<typeof sendNotificationSchema>['body'];

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const sendNotificationResponseSchema = z.object({
  dispatched: z.boolean(),
  logId: z.string().nullable(),
});

export const notificationLogSchema = z.object({
  id: z.string().uuid(),
  type: z.string(),
  targetType: z.enum(['USER', 'CITY', 'GLOBAL']),
  targetId: z.string().nullable(),
  title: z.string(),
  body: z.string(),
  onesignalId: z.string().nullable(),
  sentAt: z.date().or(z.string()),
});

export const paginatedNotificationHistoryResponseSchema = z.object({
  data: z.array(notificationLogSchema),
  meta: z.object({
    totalCount: z.number(),
    page: z.number(),
    limit: z.number(),
  }),
});

export type SendNotificationResponse = z.infer<typeof sendNotificationResponseSchema>;
export type PaginatedNotificationHistoryResponse = z.infer<typeof paginatedNotificationHistoryResponseSchema>;
