import { z } from 'zod';

// ─── Admin Login ──────────────────────────────────────────────────────────────
export const adminLoginSchema = z.object({
  email:    z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
});

// ─── Refresh Token ────────────────────────────────────────────────────────────
export const refreshSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

// ─── Logout ───────────────────────────────────────────────────────────────────
export const logoutSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type AdminLoginDto  = z.infer<typeof adminLoginSchema>;
export type RefreshDto     = z.infer<typeof refreshSchema>;
export type LogoutDto      = z.infer<typeof logoutSchema>;

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const adminLoginResponseSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  admin: z.object({
    id: z.string(),
    email: z.string(),
    name: z.string().nullable(),
  }),
});

export const refreshResponseSchema = z.object({
  accessToken: z.string(),
});

export const logoutResponseSchema = z.object({
  message: z.string(),
});

export type AdminLoginResponse = z.infer<typeof adminLoginResponseSchema>;
export type RefreshResponse = z.infer<typeof refreshResponseSchema>;
export type LogoutResponse = z.infer<typeof logoutResponseSchema>;
