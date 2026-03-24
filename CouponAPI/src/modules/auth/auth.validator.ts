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

// ─── Send OTP ─────────────────────────────────────────────────────────────────
export const sendOtpSchema = z.object({
  phone: z.string().regex(/^[0-9]{10}$/, 'Invalid phone number (must be 10 digits)'),
});

// ─── Verify OTP ───────────────────────────────────────────────────────────────
export const verifyOtpSchema = z.object({
  phone: z.string().regex(/^[0-9]{10}$/, 'Invalid phone number (must be 10 digits)'),
  otp: z.string().length(6, 'OTP must be exactly 6 digits'),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type AdminLoginDto  = z.infer<typeof adminLoginSchema>;
export type RefreshDto     = z.infer<typeof refreshSchema>;
export type LogoutDto      = z.infer<typeof logoutSchema>;
export type SendOtpDto     = z.infer<typeof sendOtpSchema>;
export type VerifyOtpDto   = z.infer<typeof verifyOtpSchema>;

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

export const sendOtpResponseSchema = z.object({
  message: z.string(),
});

export const verifyOtpResponseSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  user: z.object({
    id: z.string(),
    phone: z.string(),
    name: z.string().nullable(),
    email: z.string().nullable(),
    cityId: z.string().nullable(),
    areaId: z.string().nullable(),
    status: z.string(),
  }),
  isNewUser: z.boolean(),
});

export type AdminLoginResponse = z.infer<typeof adminLoginResponseSchema>;
export type RefreshResponse = z.infer<typeof refreshResponseSchema>;
export type LogoutResponse = z.infer<typeof logoutResponseSchema>;
export type SendOtpResponse = z.infer<typeof sendOtpResponseSchema>;
export type VerifyOtpResponse = z.infer<typeof verifyOtpResponseSchema>;
