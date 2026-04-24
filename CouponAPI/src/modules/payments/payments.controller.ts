import { Request, Response, NextFunction } from 'express';
import { PaymentService } from './payments.service';
import { sendSuccess } from '../../shared/utils/response';

const paymentService = new PaymentService();

export class PaymentController {

  // POST /api/v1/payments/initiate
  // Returns hash + SI details for Flutter to open PayU CheckoutPro
  initiatePayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await paymentService.initiatePayment(req.user!.userId);
      sendSuccess(res, result, 201);
    } catch (err) {
      next(err);
    }
  };

  // POST /api/v1/payments/webhook
  // PayU posts application/x-www-form-urlencoded; respond 200 immediately
  webhook = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    // Acknowledge first — PayU retries if no 200 within timeout
    res.status(200).json({ status: 'ok' });
    // Process async (fire-and-forget so we don't block the response)
    paymentService.handleWebhook(req.body as Record<string, string>).catch(console.error);
  };
}
