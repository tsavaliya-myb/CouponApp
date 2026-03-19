// ─────────────────────────────────────────────────────────────────────────────
// Project-wide constants
// All magic strings, TTLs, key prefixes, and limits live here.
// ─────────────────────────────────────────────────────────────────────────────

// ─── Redis Key Prefixes ───────────────────────────────────────────────────────
export const REDIS_PREFIX = {
  REFRESH_TOKEN: 'refresh:',
  OTP: 'otp:',
  QR_TOKEN: 'qr:',
} as const;

// ─── JWT TTLs (in seconds, for Redis EX) ─────────────────────────────────────
export const TTL = {
  REFRESH_TOKEN_SEC: 7 * 24 * 60 * 60, // 7 days
  OTP_SEC: 5 * 60,            // 5 minutes
  QR_TOKEN_SEC: 5 * 60,            // 5 minutes
} as const;

// ─── Pagination Defaults ──────────────────────────────────────────────────────
export const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_LIMIT: 20,
  MAX_LIMIT: 100,
} as const;