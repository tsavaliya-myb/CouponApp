import Razorpay from 'razorpay';
import { env } from './env';

let _razorpay: Razorpay | null = null;

/**
 * Lazily initializes the Razorpay client on first access.
 * Throws a clear error if credentials are not configured.
 */
export function getRazorpay(): Razorpay {
  if (!_razorpay) {
    if (!env.RAZORPAY_KEY_ID || !env.RAZORPAY_KEY_SECRET) {
      throw new Error(
        'Razorpay credentials not configured. Set RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET in .env'
      );
    }
    _razorpay = new Razorpay({
      key_id: env.RAZORPAY_KEY_ID,
      key_secret: env.RAZORPAY_KEY_SECRET,
    });
  }
  return _razorpay;
}
