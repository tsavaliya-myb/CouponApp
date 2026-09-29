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

  // POST /api/v1/payments/verify
  verifyPayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { razorpay_order_id, razorpay_payment_id, razorpay_signature } = req.body as {
        razorpay_order_id?: string;
        razorpay_payment_id?: string;
        razorpay_signature?: string;
      };
      if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature) {
        res.status(400).json({ success: false, message: 'razorpay_order_id, razorpay_payment_id and razorpay_signature are required' });
        return;
      }
      const result = await paymentService.verifyPayment(req.user!.userId, {
        orderId:   razorpay_order_id,
        paymentId: razorpay_payment_id,
        signature: razorpay_signature,
      });
      sendSuccess(res, result);
    } catch (err) {
      log.error('verifyPayment: unhandled error', { userId: req.user?.userId, err });
      next(err);
    }
  };

  // POST /api/v1/payments/webhook
  // Razorpay retries on non-2xx for up to 24h — process synchronously so a
  // crash between "respond 200" and "process" can no longer silently lose events.
  // We set a 4-second timeout so slow Razorpay API calls inside handleWebhook
  // don't push us past Razorpay's own 5s response deadline.
  webhook = async (req: Request, res: Response, _next: NextFunction): Promise<void> => {
    const signature = req.headers['x-razorpay-signature'] as string | undefined;
    log.info('webhook: HTTP request received', { hasSignature: !!signature });

    // Abort the processing if it takes longer than 4s so we can still respond.
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 4000);

    try {
      await Promise.race([
        paymentService.handleWebhook(req.body as Buffer, signature ?? ''),
        new Promise<never>((_, reject) =>
          controller.signal.addEventListener('abort', () =>
            reject(new Error('webhook: processing timed out (4s) — Razorpay will retry'))
          )
        ),
      ]);
      clearTimeout(timer);
      res.status(200).json({ status: 'ok' });
    } catch (err) {
      clearTimeout(timer);
      log.error('webhook: processing failed or timed out', { err });
      // Non-2xx → Razorpay will retry.  Do NOT return 200 on error.
      res.status(500).json({ status: 'error' });
    }
  };

  // POST /api/v1/payments/cancel-autopay
  cancelAutopay = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await paymentService.cancelAutopay(req.user!.userId);
      sendSuccess(res, { message: 'Autopay successfully cancelled' });
    } catch (err) {
      log.error('cancelAutopay: unhandled error', { userId: req.user?.userId, err });
      next(err);
    }
  };

  // GET /api/v1/payments/history
  getPaymentHistory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await paymentService.getPaymentHistory(req.user!.userId);
      sendSuccess(res, result);
    } catch (err) {
      log.error('getPaymentHistory: unhandled error', { userId: req.user?.userId, err });
      next(err);
    }
  };
}
