import { Express } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import hpp from 'hpp';
import { env } from '../../config/env';

export function applySecurityMiddleware(app: Express): void {
  // HTTP security headers
  app.use(
    helmet({
      contentSecurityPolicy: env.isProduction,
      crossOriginEmbedderPolicy: env.isProduction,
    })
  );

  // CORS
  app.use(
    cors({
      origin: env.CORS_ORIGIN === '*' ? '*' : env.CORS_ORIGIN.split(','),
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
      credentials: true,
    })
  );

  // HTTP Parameter Pollution prevention
  app.use(hpp());

  // Rate limiting — global API routes
  app.use(
    '/api/',
    rateLimit({
      windowMs: env.RATE_LIMIT_WINDOW_MS,
      max: env.RATE_LIMIT_MAX,
      standardHeaders: true,
      legacyHeaders: false,
      message: { success: false, code: 'RATE_LIMITED', message: 'Too many requests' },
    })
  );

  // Stricter limit for auth routes (20 attempts per 15 min)
  app.use(
    '/api/v1/auth/',
    rateLimit({
      windowMs: 15 * 60 * 1000,
      max: 20,
      message: { success: false, code: 'RATE_LIMITED', message: 'Too many auth attempts' },
    })
  );
}
