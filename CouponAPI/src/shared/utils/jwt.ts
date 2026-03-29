import jwt from 'jsonwebtoken';
import { env } from '../../config/env';
import { UserRole } from '../types/roles';

export interface JwtPayload {
  userId: string;
  role:   UserRole;
  phone?: string;
  email?: string;
}

/**
 * Signs a short-lived access token (24h).
 */
export const signAccessToken = (payload: JwtPayload): string =>
  jwt.sign(payload, env.JWT_SECRET, { expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'] });

/**
 * Signs a long-lived refresh token (7d).
 */
export const signRefreshToken = (payload: JwtPayload): string =>
  jwt.sign(payload, env.JWT_REFRESH_SECRET, { expiresIn: env.JWT_REFRESH_EXPIRES_IN as jwt.SignOptions['expiresIn'] });

/**
 * Verifies an access token and returns the decoded payload.
 * Throws if invalid or expired.
 */
export const verifyAccessToken = (token: string): JwtPayload =>
  jwt.verify(token, env.JWT_SECRET) as JwtPayload;

/**
 * Verifies a refresh token and returns the decoded payload.
 * Throws if invalid or expired.
 */
export const verifyRefreshToken = (token: string): JwtPayload =>
  jwt.verify(token, env.JWT_REFRESH_SECRET) as JwtPayload;

/**
 * Signs a short-lived registration token (15 mins) for sellers who verified OTP but haven't registered.
 */
export const signRegistrationToken = (phone: string): string =>
  jwt.sign({ phone, role: 'registration_only' }, env.JWT_SECRET, { expiresIn: '15m' });

/**
 * Verifies a registration token. Throws if invalid, expired, or wrong role.
 */
export const verifyRegistrationToken = (token: string): { phone: string } => {
  const payload = jwt.verify(token, env.JWT_SECRET) as any;
  if (payload.role !== 'registration_only' || !payload.phone) {
    throw new Error('Invalid registration token');
  }
  return { phone: payload.phone };
};

/**
 * Signs a short-lived QR identity token (5 min) for the user QR code screen.
 */
export const signQrToken = (userId: string): string =>
  jwt.sign({ userId, purpose: 'qr_scan' }, env.JWT_SECRET, { expiresIn: '5m' });

/**
 * Verifies a QR token scanned by the seller app.
 */
export const verifyQrToken = (token: string): { userId: string; purpose: string } =>
  jwt.verify(token, env.JWT_SECRET) as { userId: string; purpose: string };
