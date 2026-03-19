import { Response } from 'express';

interface PaginationMeta {
  page:       number;
  limit:      number;
  total:      number;
  totalPages: number;
}

export const sendSuccess = <T>(
  res: Response,
  data: T,
  statusCode = 200,
  meta?: PaginationMeta
): void => {
  res.status(statusCode).json({
    success: true,
    data,
    ...(meta && { meta }),
  });
};

export const sendCreated = <T>(res: Response, data: T): void =>
  sendSuccess(res, data, 201);

export const sendNoContent = (res: Response): void => {
  res.status(204).send();
};
