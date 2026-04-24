import crypto from 'crypto';

interface HashParams {
  txnid:       string;
  amount:      string;
  productinfo: string;
  firstname:   string;
  email:       string;
  udf1?: string;
  udf2?: string;
  udf3?: string;
  udf4?: string;
  udf5?: string;
}

interface SIHashParams {
  billingAmount:    string;
  billingCurrency:  string;
  billingCycle:     string;
  billingInterval:  number;
  paymentStartDate: string;
  paymentEndDate:   string;
  billingRule?:     string;
}

/**
 * Generate SHA-512 hash for a regular (non-SI) PayU payment request.
 * Formula: key|txnid|amount|productinfo|firstname|email|udf1|...|udf5||||||SALT
 */
export function generatePayUHash(p: HashParams, key: string, salt: string): string {
  const { txnid, amount, productinfo, firstname, email } = p;
  const u1 = p.udf1 || '';
  const u2 = p.udf2 || '';
  const u3 = p.udf3 || '';
  const u4 = p.udf4 || '';
  const u5 = p.udf5 || '';
  const str = `${key}|${txnid}|${amount}|${productinfo}|${firstname}|${email}|${u1}|${u2}|${u3}|${u4}|${u5}||||||${salt}`;
  return crypto.createHash('sha512').update(str).digest('hex');
}

/**
 * Generate SHA-512 hash for a Standing Instruction (SI/UPI Autopay) payment.
 * Formula: key|txnid|amount|...|udf5||||||si_details_json|SALT
 *
 * The si_details JSON must match exactly what the PayU SDK passes internally.
 */
export function generateSIPayUHash(
  p: HashParams,
  si: SIHashParams,
  key: string,
  salt: string,
): string {
  const { txnid, amount, productinfo, firstname, email } = p;
  const u1 = p.udf1 || '';
  const u2 = p.udf2 || '';
  const u3 = p.udf3 || '';
  const u4 = p.udf4 || '';
  const u5 = p.udf5 || '';

  // Build si_details JSON in the exact field order PayU expects.
  const siJson = JSON.stringify({
    billingAmount:    si.billingAmount,
    billingCurrency:  si.billingCurrency,
    billingCycle:     si.billingCycle,
    billingInterval:  si.billingInterval,
    paymentStartDate: si.paymentStartDate,
    paymentEndDate:   si.paymentEndDate,
    ...(si.billingRule ? { billingRule: si.billingRule } : {}),
  });

  const str = `${key}|${txnid}|${amount}|${productinfo}|${firstname}|${email}|${u1}|${u2}|${u3}|${u4}|${u5}||||||${siJson}|${salt}`;
  return crypto.createHash('sha512').update(str).digest('hex');
}

/**
 * Generate static hashes required by the PayU CheckoutPro mobile SDK.
 *
 * - payment_related_details_for_mobile_sdk: required for checkout screen to
 *   display payment options. Formula: SHA512(key|payment_related_details_for_mobile_sdk|userCredential|salt)
 * - vas_for_mobile_sdk: required for EMI/VAS details.
 *   Formula: SHA512(key|vas_for_mobile_sdk|default|salt)
 *
 * Both must be passed in additionalParam before openCheckoutScreen is called.
 */
export function generateMobileSDKStaticHashes(
  key: string,
  userCredential: string,
  salt: string,
): { payment_related_details_for_mobile_sdk: string; vas_for_mobile_sdk: string } {
  const hash512 = (s: string) => crypto.createHash('sha512').update(s).digest('hex');
  return {
    payment_related_details_for_mobile_sdk: hash512(`${key}|payment_related_details_for_mobile_sdk|${userCredential}|${salt}`),
    vas_for_mobile_sdk: hash512(`${key}|vas_for_mobile_sdk|default|${salt}`),
  };
}

/**
 * Compute SHA-512 hash from the raw hashString provided by the PayU SDK's
 * generateHash callback. The SDK supplies the complete string up to (but not
 * including) the salt; we append salt and hash.
 *
 * Formula: SHA512(hashString + salt)
 */
export function computeHashFromString(hashString: string, salt: string): string {
  return crypto.createHash('sha512').update(hashString + salt).digest('hex');
}

/**
 * Verify the reverse hash sent by PayU in the S2S webhook.
 * Formula: SALT|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key
 */
export function verifyPayUWebhookHash(
  body: Record<string, string>,
  salt: string,
): boolean {
  const received = body.hash;
  if (!received) return false;

  const {
    status = '', udf5 = '', udf4 = '', udf3 = '', udf2 = '', udf1 = '',
    email = '', firstname = '', productinfo = '', amount = '', txnid = '', key = '',
  } = body;

  const str = `${salt}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;
  const computed = crypto.createHash('sha512').update(str).digest('hex');
  return computed.toLowerCase() === received.toLowerCase();
}
