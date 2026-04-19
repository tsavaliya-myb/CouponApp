import { env } from '../../config/env';

export async function sendOtpViaMSG91(phone: string, otp: string): Promise<void> {
  const mobile = `91${phone}`;

  const params = new URLSearchParams({
    otp,
    mobile,
    authkey: env.MSG91_AUTH_KEY,
    template_id: env.MSG91_TEMPLATE_ID,
  });

  const response = await fetch(`https://control.msg91.com/api/v5/otp?${params}`, {
    method: 'GET',
  });

  const data = (await response.json()) as { type: string; message: string };

  if (!response.ok || data.type !== 'success') {
    throw new Error(`MSG91 error: ${data.message}`);
  }
}
