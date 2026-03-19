export class AppError extends Error {
  public readonly statusCode: number;
  public readonly isOperational: boolean;
  public readonly code?: string;
  public issues?: Array<{ field: string; message: string }>;

  constructor(message: string, statusCode: number, code?: string, isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    this.code = code;
    Object.setPrototypeOf(this, AppError.prototype);
    Error.captureStackTrace(this, this.constructor);
  }
}

// ─────────────────────────────────────────
// Common error factories
// ─────────────────────────────────────────

export const NotFoundError = (resource: string): AppError =>
  new AppError(`${resource} not found`, 404, 'NOT_FOUND');

export const UnauthorizedError = (msg = 'Unauthorized'): AppError =>
  new AppError(msg, 401, 'UNAUTHORIZED');

export const ForbiddenError = (msg = 'Forbidden'): AppError =>
  new AppError(msg, 403, 'FORBIDDEN');

export const ValidationError = (msg: string): AppError =>
  new AppError(msg, 400, 'VALIDATION_ERROR');

export const ConflictError = (msg: string): AppError =>
  new AppError(msg, 409, 'CONFLICT');

export const BadRequestError = (msg: string): AppError =>
  new AppError(msg, 400, 'BAD_REQUEST');
