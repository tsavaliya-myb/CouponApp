import { S3Client, GetObjectCommand, PutObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { env } from './env';

export const s3Client = new S3Client({
  region: env.IDRIVE_E2_REGION,
  endpoint: `https://s3.${env.IDRIVE_E2_REGION}.idrivee2.com`,
  credentials: {
    accessKeyId: env.IDRIVE_E2_ACCESS_KEY,
    secretAccessKey: env.IDRIVE_E2_SECRET_KEY,
  },
  forcePathStyle: true,
});

export const BUCKET_NAME = env.IDRIVE_E2_BUCKET_NAME;
export const BUCKET_REGION = env.IDRIVE_E2_REGION;

/**
 * Returns a PERMANENT URL that routes through our API media proxy.
 * Format: <API_BASE_URL>/media/<fileKey>
 * e.g.   https://api.example.com/media/logos/1234-uuid.jpeg
 *
 * These URLs never expire. The bucket stays private; the API streams
 * the S3 object on demand.
 */
export const getPublicUrl = (fileKey: string): string =>
  `${env.API_BASE_URL}/media/${fileKey}`;

/**
 * Extracts the S3 key from a stored proxy URL.
 * Stored URLs: <API_BASE_URL>/media/<key>
 */
export const extractKeyFromProxyUrl = (url: string): string | null => {
  try {
    const parsed = new URL(url);
    const prefix = '/media/';
    return parsed.pathname.startsWith(prefix)
      ? parsed.pathname.slice(prefix.length)
      : null;
  } catch {
    return null;
  }
};

/**
 * Generates a short-lived pre-signed PUT URL for direct S3 upload from the client.
 * Used only for the upload flow (presign → Flutter uploads → confirm).
 */
export const getPresignedUploadUrl = async (
  fileKey: string,
  mimeType: string,
  expiresIn = 300,
): Promise<string> => {
  const command = new PutObjectCommand({
    Bucket: BUCKET_NAME,
    Key: fileKey,
    ContentType: mimeType,
  });
  return getSignedUrl(s3Client, command, { expiresIn });
};

export { GetObjectCommand, DeleteObjectCommand };
