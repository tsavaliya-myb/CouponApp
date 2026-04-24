import { env } from './env';

export const payuConfig = {
  key:     env.PAYU_KEY,
  salt:    env.PAYU_SALT,
  baseUrl: env.PAYU_ENV === 'production'
    ? 'https://secure.payu.in'
    : 'https://test.payu.in',
};
