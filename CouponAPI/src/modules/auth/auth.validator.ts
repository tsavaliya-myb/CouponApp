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

// ─── Seller Send OTP ──────────────────────────────────────────────────────────
export const sellerSendOtpSchema = z.object({
  phone: z.string().regex(/^[0-9]{10}$/, 'Invalid phone number (must be 10 digits)'),
});

// ─── Seller Verify OTP ────────────────────────────────────────────────────────
export const sellerVerifyOtpSchema = z.object({
  phone: z.string().regex(/^[0-9]{10}$/, 'Invalid phone number (must be 10 digits)'),
  otp: z.string().length(6, 'OTP must be exactly 6 digits'),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type AdminLoginDto  = z.infer<typeof adminLoginSchema>;
export type RefreshDto     = z.infer<typeof refreshSchema>;
export type LogoutDto      = z.infer<typeof logoutSchema>;
export type SendOtpDto     = z.infer<typeof sendOtpSchema>;
export type VerifyOtpDto   = z.infer<typeof verifyOtpSchema>;
export type SellerSendOtpDto = z.infer<typeof sellerSendOtpSchema>;
export type SellerVerifyOtpDto = z.infer<typeof sellerVerifyOtpSchema>;

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
    subscriptionStatus: z.enum(['ACTIVE', 'NONE']),
  }),
  isNewUser: z.boolean(),
});

export const sellerSendOtpResponseSchema = z.object({
  message: z.string(),
});

export const sellerVerifyOtpResponseSchema = z.union([
  z.object({
    isRegistered: z.literal(true),
    status: z.string(),
    accessToken: z.string(),
    refreshToken: z.string(),
  }),
  z.object({
    isRegistered: z.literal(false),
    registrationToken: z.string(),
  }),
]);

export type AdminLoginResponse = z.infer<typeof adminLoginResponseSchema>;
export type RefreshResponse = z.infer<typeof refreshResponseSchema>;
export type LogoutResponse = z.infer<typeof logoutResponseSchema>;
export type SendOtpResponse = z.infer<typeof sendOtpResponseSchema>;
export type VerifyOtpResponse = z.infer<typeof verifyOtpResponseSchema>;
export type SellerSendOtpResponse = z.infer<typeof sellerSendOtpResponseSchema>;
export type SellerVerifyOtpResponse = z.infer<typeof sellerVerifyOtpResponseSchema>;
