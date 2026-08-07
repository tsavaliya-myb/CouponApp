import express, { Express } from 'express';
import morgan from 'morgan';
import path from 'path';
import { applySecurityMiddleware } from './shared/middlewares/security';
import { errorHandler, notFoundHandler } from './shared/middlewares/errorHandler';
import { logger } from './config/logger';
import { env } from './config/env';
import { apiRouter } from './routes';
import { mediaRouter } from './modules/media/media.routes';

export function createApp(): Express {
  const app = express();

  // Trust proxy (for nginx/load balancers in production)
  if (env.isProduction) app.set('trust proxy', 1);

  // Security middleware stack
  applySecurityMiddleware(app);

  // Body parsing
  // The Razorpay webhook needs the untouched raw bytes to verify its HMAC
  // signature (re-serializing parsed JSON will not byte-match what Razorpay
  // signed), so that route parses its own body via express.raw() and must
  // never pass through the global JSON/urlencoded parsers below.
  const isRazorpayWebhook = (req: express.Request) => req.path === '/api/v1/payments/webhook';

  app.use((req, res, next) => (isRazorpayWebhook(req) ? next() : express.json({ limit: '10mb' })(req, res, next)));
  app.use((req, res, next) => (isRazorpayWebhook(req) ? next() : express.urlencoded({ extended: true, limit: '10mb' })(req, res, next)));

  // HTTP request logging (skip /health to reduce noise)
  app.use(
    morgan('combined', {
      stream: { write: (msg) => logger.http(msg.trim()) },
      skip: (req) => req.path === '/health',
    })
  );

  // Health check endpoint (no auth, no rate limit)
  app.get('/health', (_req, res) => {
    res.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: env.NODE_ENV,
    });
  });

  // Serve static uploads
  // app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));
  app.use('/uploads', express.static('/tmp/uploads'));

  // Media proxy — serves private S3 objects via permanent URLs (no auth needed)
  // URLs: GET /media/logos/file.jpeg, /media/photos/file.jpeg, /media/videos/file.mp4
  app.use('/media', mediaRouter);

  // API routes (versioned)
  app.use('/api/v1', apiRouter);

  // Swagger Documentation
  if (!env.isProduction || env.SWAGGER_ENABLED === 'true') {
    const { setupSwagger } = require('./config/swagger');
    setupSwagger(app);
  }

  // 404 + global error handler — must be last
  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}
