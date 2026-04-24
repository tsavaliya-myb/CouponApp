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

  // POST /api/v1/payments/generate-hash
  // Called by Flutter's PayU SDK generateHash callback; keeps salt off the client
  generateHash = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { hash_string } = req.body as { hash_string?: string };
      if (!hash_string || typeof hash_string !== 'string') {
        res.status(400).json({ success: false, message: 'hash_string is required' });
        return;
      }
      const hash = paymentService.generateHash(hash_string);
      sendSuccess(res, { hash });
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
