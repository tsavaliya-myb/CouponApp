import { Request, Response, NextFunction } from 'express';
import { PaymentService } from './payments.service';
import { logger } from '../../config/logger';
import { sendSuccess } from '../../shared/utils/response';

const paymentService = new PaymentService();
const log = logger.child({ module: 'PaymentController' });

export class PaymentController {

  // POST /api/v1/payments/initiate
  initiatePayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await paymentService.initiatePayment(req.user!.userId);
      sendSuccess(res, result, 201);
    } catch (err) {
      log.error('initiatePayment: unhandled error', { userId: req.user?.userId, err });
      next(err);
    }
  };

  // POST /api/v1/payments/generate-hash
  generateHash = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { hash_string } = req.body as { hash_string?: string };
      if (!hash_string || typeof hash_string !== 'string') {
        log.warn('generateHash: missing or invalid hash_string', { userId: req.user?.userId });
        res.status(400).json({ success: false, message: 'hash_string is required' });
        return;
      }
      const hash = paymentService.generateHash(hash_string);
      sendSuccess(res, { hash });
    } catch (err) {
      log.error('generateHash: unhandled error', { userId: req.user?.userId, err });
      next(err);
    }
  };

  // POST /api/v1/payments/webhook
  // Respond 200 immediately — PayU retries on non-2xx
  webhook = async (req: Request, res: Response, _next: NextFunction): Promise<void> => {
    const { txnid, mihpayid, status } = req.body as Record<string, string>;
    log.info('webhook: HTTP request received', { txnid, mihpayid, status });

    res.status(200).json({ status: 'ok' });

    paymentService.handleWebhook(req.body as Record<string, string>).catch((err) => {
      log.error('webhook: unhandled error in async processing', { txnid, mihpayid, err });
    });
  };
}
