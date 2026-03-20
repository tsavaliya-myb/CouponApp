import { z } from 'zod';

export const updateSettingsSchema = z.object({
  body: z.object({
    settings: z.record(z.string(), z.string().or(z.number())),
  }),
});

export type UpdateSettingsBody = z.infer<typeof updateSettingsSchema>['body'];

export const appSettingsResponseSchema = z.record(z.string(), z.string());
export type AppSettingsResponse = z.infer<typeof appSettingsResponseSchema>;
