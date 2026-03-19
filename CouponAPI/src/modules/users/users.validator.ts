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

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type RegisterUserDto = z.infer<typeof registerUserSchema>;
export type UpdateUserDto = z.infer<typeof updateUserSchema>;
