import { z } from 'zod';

// ─── Customer Registration ────────────────────────────────────────────────────
export const registerUserSchema = z.object({
  phone: z.string().regex(/^[0-9]{10}$/, 'Phone number must be exactly 10 digits'),
  name: z.string().min(2, 'Name is required').max(100),
  email: z.string().email('Invalid email address').optional(),
  cityId: z.string().uuid('Invalid City ID').optional(),
  areaId: z.string().uuid('Invalid Area ID').optional(),
});

// ─── Customer Profile Update ──────────────────────────────────────────────────
export const updateUserSchema = z.object({
  name: z.string().min(2).max(100).optional(),
  email: z.string().email('Invalid email address').optional(),
  cityId: z.string().uuid('Invalid City ID').optional(),
  areaId: z.string().uuid('Invalid Area ID').optional(),
});

export type RegisterUserDto = z.infer<typeof registerUserSchema>;
export type UpdateUserDto = z.infer<typeof updateUserSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseUserResponseSchema = z.object({
  id: z.string().uuid(),
  phone: z.string(),
  name: z.string().nullable().optional(), // prisma returns nullable for name
  email: z.string().nullable().optional(),
  cityId: z.string().uuid().nullable().optional(),
  areaId: z.string().uuid().nullable().optional(),
  status: z.enum(['ACTIVE', 'BLOCKED']),
});

export const profileResponseSchema = baseUserResponseSchema.extend({
  city: z.object({ id: z.string(), name: z.string() }).nullable().optional(),
  area: z.object({ id: z.string(), name: z.string() }).nullable().optional(),
  subscriptionStatus: z.enum(['ACTIVE', 'NONE']).optional(),
});

export const loginUserResponseSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  user: baseUserResponseSchema,
});

export const qrTokenResponseSchema = z.object({
  qrToken: z.string(),
  qrImageBase64: z.string(),
  expiresInSeconds: z.number(),
});

export type BaseUserResponse = z.infer<typeof baseUserResponseSchema>;
export type ProfileResponse = z.infer<typeof profileResponseSchema>;
export type LoginUserResponse = z.infer<typeof loginUserResponseSchema>;
export type QrTokenResponse = z.infer<typeof qrTokenResponseSchema>;
