import { Request, Response, NextFunction } from 'express';
import { AdminPaymentsService } from './admin-payments.service';
import type { AdminPaymentsQueryDto } from './admin-payments.validator';

const adminPaymentsService = new AdminPaymentsService();

export class AdminPaymentsController {

  // ─── List Payment Attempts ─────────────────────────────────────────────────────
  listPayments = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      // req.query is validated and parsed by Zod middleware
      const query = req.query as unknown as AdminPaymentsQueryDto;
      const result = await adminPaymentsService.listPayments(query);

      res.status(200).json({
        success: true,
        data: result.data,
        meta: result.meta,
      });
    } catch (err) {
      next(err);
    }
  };
}
