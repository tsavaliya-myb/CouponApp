import { S3Client } from '@aws-sdk/client-s3';
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

/** Public URL for a given S3 key in the seller-media bucket */
export const getPublicUrl = (fileKey: string): string =>
  `https://s3.${env.IDRIVE_E2_REGION}.idrivee2.com/${env.IDRIVE_E2_BUCKET_NAME}/${fileKey}`;
