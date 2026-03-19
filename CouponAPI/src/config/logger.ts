import winston from 'winston';
import { env } from './env';

const { combine, timestamp, errors, json, colorize, simple } = winston.format;

export const logger = winston.createLogger({
  level: env.LOG_LEVEL,
  format: combine(
    timestamp({ format: 'YYYY-MM-DDTHH:mm:ss.SSSZ' }),
    errors({ stack: true }),
    json()
  ),
  defaultMeta: { service: 'coupon-api' },
  transports: [
    new winston.transports.Console({
      format: env.NODE_ENV === 'development' ? combine(colorize(), simple()) : json(),
    }),
    ...(env.isProduction
      ? [
          new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
          new winston.transports.File({ filename: 'logs/combined.log' }),
        ]
      : []),
  ],
});
