import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../../config/env';
import { UnauthorizedError, ForbiddenError } from '../utils/AppError';
import { ROLES, UserRole } from '../types/roles';

export interface JwtPayload {
  userId: string;
  role:   UserRole;
  phone?: string;
  email?: string;
  iat:    number;
  exp:    number;
}

/**
 * Verifies the Bearer JWT in the Authorization header.
 * Attaches the decoded payload to req.user.
 */
export const authenticate = (req: Request, _res: Response, next: NextFunction): void => {
  const authHeader = req.headers.authorization;

  if (!authHeader?.startsWith('Bearer ')) {
    return next(UnauthorizedError('No token provided'));
  }

  const token = authHeader.split(' ')[1];
  try {
    req.user = jwt.verify(token, env.JWT_SECRET) as JwtPayload;
    next();
  } catch {
    next(UnauthorizedError('Invalid or expired token'));
  }
};

/**
 * Role-based access control guard.
 * Must be used AFTER authenticate().
 *
 * @example
 * router.get('/admin/users', authenticate, authorize('admin'), controller.list)
 */
export const authorize = (...roles: UserRole[]) =>
  (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.user) return next(UnauthorizedError());
    if (!roles.includes(req.user.role)) {
      return next(ForbiddenError('Insufficient permissions'));
    }
    next();
  };
