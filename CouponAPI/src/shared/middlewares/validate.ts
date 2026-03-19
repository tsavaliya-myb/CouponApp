import { Request, Response, NextFunction } from 'express';
import { ZodSchema } from 'zod';
import { AppError } from '../utils/AppError';

type Target = 'body' | 'query' | 'params';

export const validate =
  (schema: ZodSchema, target: Target = 'body') =>
  (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req[target]);
    if (!result.success) {
      const issues = result.error.issues.map((e) => ({
        field: e.path.join('.'),
        message: e.message,
      }));
      const err = new AppError('Validation failed', 400, 'VALIDATION_ERROR');
      err.issues = issues;
      return next(err);
    }
    req[target] = result.data;
    next();
  };
