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
 *
 * Non-SI: SHA512(SALT|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key)
 * SI:     SHA512(SALT|si_details|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key)
 *
 * If `additionalCharges` is present it is prepended to the entire string.
 * We try all valid candidate strings so this works for both SI and non-SI webhooks.
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
    si_details = '', additionalCharges = '',
  } = body;

  const hash512 = (s: string) => crypto.createHash('sha512').update(s).digest('hex').toLowerCase();

  const core    = `${salt}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;
  const withSi  = `${salt}|${si_details}|${status}||||||${udf5}|${udf4}|${udf3}|${udf2}|${udf1}|${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;

  const candidates = si_details ? [withSi, core] : [core];
  const all = additionalCharges
    ? [...candidates.map(s => `${additionalCharges}|${s}`), ...candidates]
    : candidates;

  return all.some(s => hash512(s) === received.toLowerCase());
}
