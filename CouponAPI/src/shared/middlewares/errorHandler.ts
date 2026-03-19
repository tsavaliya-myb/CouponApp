import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/AppError';
import { logger } from '../../config/logger';
import { env } from '../../config/env';

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (err instanceof AppError) {
    logger.warn({
      message: err.message,
      code: err.code,
      path: req.path,
      method: req.method,
      ...(err.issues && { issues: err.issues }),
    });
    res.status(err.statusCode).json({
      success: false,
      code: err.code,
      message: err.message,
      ...(err.issues && { issues: err.issues }),
    });
    return;
  }

  // Unhandled / programming errors
  logger.error({ message: err.message, stack: err.stack, path: req.path });
  res.status(500).json({
    success: false,
    code: 'INTERNAL_ERROR',
    message: env.isProduction ? 'Something went wrong' : err.message,
    ...(env.isDevelopment && { stack: err.stack }),
  });
};

export const notFoundHandler = (req: Request, _res: Response, next: NextFunction): void => {
  next(new AppError(`Route ${req.originalUrl} not found`, 404, 'ROUTE_NOT_FOUND'));
};
