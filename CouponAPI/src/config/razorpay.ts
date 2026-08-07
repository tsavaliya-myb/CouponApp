import Razorpay from 'razorpay';
import { env } from './env';

export const razorpay = new Razorpay({
  key_id:     env.RAZORPAY_KEY_ID,
  key_secret: env.RAZORPAY_KEY_SECRET,
});

export const isLiveMode = env.RAZORPAY_KEY_ID.startsWith('rzp_live_');

/** ₹ → paise. Razorpay rejects non-integer amounts. */
export const toPaise = (rupees: number | string): number => Math.round(Number(rupees) * 100);

/** paise → ₹ (2dp string, for Decimal columns). */
export const toRupees = (paise: number): string => (paise / 100).toFixed(2);
