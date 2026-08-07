import { cleanEnv, str, port, num, url } from 'envalid';

export const env = cleanEnv(process.env, {
  NODE_ENV:             str({ choices: ['development', 'test', 'production'], default: 'development' }),
  PORT:                 port({ default: 3000 }),

  // Database
  DATABASE_URL:         str({ default: 'postgresql://user:password@localhost:5432/coupondb' }),

  // Redis
  REDIS_URL:            str({ default: 'redis://localhost:6379' }),

  // JWT
  JWT_SECRET:           str({ default: 'change-me-in-production' }),
  JWT_EXPIRES_IN:       str({ default: '30d' }),
  JWT_REFRESH_SECRET:   str({ default: 'change-refresh-secret-in-production' }),
  JWT_REFRESH_EXPIRES_IN: str({ default: '60d' }),

  // Password hashing
  BCRYPT_ROUNDS:        num({ default: 12 }),

  // Rate limiting
  RATE_LIMIT_WINDOW_MS: num({ default: 15 * 60 * 1000 }),
  RATE_LIMIT_MAX:       num({ default: 100 }),

  // CORS
  CORS_ORIGIN:          str({ default: '*' }),

  // Logging
  LOG_LEVEL:            str({ choices: ['error', 'warn', 'info', 'http', 'debug'], default: 'info' }),

  // MSG91 (OTP SMS)
  MSG91_AUTH_KEY:       str({ default: '' }),
  MSG91_TEMPLATE_ID:    str({ default: '' }),
  MSG91_SENDER_ID:      str({ default: 'CPNAPP' }),

  // Razorpay
  RAZORPAY_KEY_ID:         str({ default: '' }),
  RAZORPAY_KEY_SECRET:     str({ default: '' }),
  RAZORPAY_WEBHOOK_SECRET: str({ default: '' }),
  // UPI Autopay mandate ceiling in paise (₹5,000 confirmed for this account;
  // UPI Autopay's own hard cap without extra authentication is ₹15,000/1500000).
  RAZORPAY_MANDATE_MAX_AMOUNT: num({ default: 500_000 }),
  // Mandate validity in years (token.expire_at)
  RAZORPAY_MANDATE_YEARS:      num({ default: 10 }),

  // OneSignal
  ONESIGNAL_APP_ID:     str({ default: '' }),
  ONESIGNAL_REST_API_KEY: str({ default: '' }),

  // iDrive E2 S3 Storage
  IDRIVE_E2_ACCESS_KEY:  str({ default: '' }),
  IDRIVE_E2_SECRET_KEY:  str({ default: '' }),
  IDRIVE_E2_BUCKET_NAME: str({ default: 'seller-media' }),
  IDRIVE_E2_REGION:      str({ default: '' }),

  // API public base URL — used for generating permanent media proxy URLs
  // e.g. https://api.yourdomain.com  (no trailing slash)
  API_BASE_URL:          str({ default: 'http://localhost:3000' }),

  // Swagger — enable in production by setting to 'true'
  SWAGGER_ENABLED:       str({ default: 'false' }),

  // Leegality
  LEEGALITY_PRIVATE_SALT: str({ default: '' }),
});
