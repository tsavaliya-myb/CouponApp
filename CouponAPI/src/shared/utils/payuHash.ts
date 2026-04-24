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
 * Generate SHA-512 hash for a PayU payment request.
 * Formula: key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||SALT
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
 * generateHash callback. The SDK supplies the string up to (but not including)
 * the salt; we append the salt and hash the result.
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
