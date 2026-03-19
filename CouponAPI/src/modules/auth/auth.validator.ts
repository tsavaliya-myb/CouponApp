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
