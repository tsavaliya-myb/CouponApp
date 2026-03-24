import { Request, Response, NextFunction } from 'express';
import { PaymentService } from './payments.service';
import { sendSuccess } from '../../shared/utils/response';

const paymentService = new PaymentService();

export class PaymentController {

  // POST /api/v1/payments/create-order
  createOrder = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await paymentService.createOrder(userId);
      sendSuccess(res, result, 201);
    } catch (err) {
      next(err);
    }
  };

  // POST /api/v1/payments/webhook
  webhook = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      // Acknowledge receipt immediately — Razorpay retries if no 200 within 5s
      res.status(200).json({ status: 'ok' });
      // Process async after response is sent
      await paymentService.handleWebhook(req.body);
    } catch (err) {
      next(err);
    }
  };
}
