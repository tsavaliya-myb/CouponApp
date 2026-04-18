import { env } from '../../config/env';

export async function sendOtpViaMSG91(phone: string, otp: string): Promise<void> {
  const mobile = `91${phone}`;

  const response = await fetch('https://control.msg91.com/api/v5/otp', {
    method: 'POST',
    headers: {
      authkey: env.MSG91_AUTH_KEY,
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      template_id: env.MSG91_TEMPLATE_ID,
      mobile,
      otp,
    }),
  });

  const data = (await response.json()) as { type: string; message: string };

  if (!response.ok || data.type !== 'success') {
    throw new Error(`MSG91 error: ${data.message}`);
  }
}
