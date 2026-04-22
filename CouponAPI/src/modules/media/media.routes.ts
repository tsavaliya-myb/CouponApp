import { Router, Request, Response } from 'express';
import { GetObjectCommand } from '@aws-sdk/client-s3';
import { s3Client, BUCKET_NAME } from '../../config/s3';

/**
 * Public media proxy router.
 * 
 * Serves private iDrive E2 S3 objects through the API server.
 * URLs are permanent and never expire:
 *   GET /media/logos/filename.jpeg
 *   GET /media/photos/filename.jpeg
 *   GET /media/videos/filename.mp4
 * 
 * No authentication required — the bucket remains private,
 * but the API acts as a secure proxy.
 */
const router = Router();

// Allowed folders — prevents arbitrary key traversal
const ALLOWED_FOLDERS = new Set(['logos', 'photos', 'videos']);

router.get('/*', async (req: Request, res: Response) => {
  // req.params[0] is everything after /media/
  const rawKey = (req.params as any)[0] as string;

  if (!rawKey) {
    res.status(400).json({ error: 'Missing media key' });
    return;
  }

  // Validate the top-level folder to prevent path traversal
  const folder = rawKey.split('/')[0];
  if (!ALLOWED_FOLDERS.has(folder)) {
    res.status(404).json({ error: 'Not found' });
    return;
  }

  // Prevent path traversal attacks
  if (rawKey.includes('..') || rawKey.includes('%2e%2e')) {
    res.status(400).json({ error: 'Invalid path' });
    return;
  }

  try {
    const command = new GetObjectCommand({
      Bucket: BUCKET_NAME,
      Key: rawKey,
    });

    const s3Response = await s3Client.send(command);

    // Forward the Content-Type so images/videos render correctly
    if (s3Response.ContentType) {
      res.setHeader('Content-Type', s3Response.ContentType);
    }
    if (s3Response.ContentLength) {
      res.setHeader('Content-Length', s3Response.ContentLength);
    }

    // Cache in browser / CDN for 24 hours
    res.setHeader('Cache-Control', 'public, max-age=86400, immutable');

    // Stream body directly to client — no buffering in memory
    (s3Response.Body as NodeJS.ReadableStream).pipe(res);
  } catch (err: any) {
    if (err.name === 'NoSuchKey' || err.$metadata?.httpStatusCode === 404) {
      res.status(404).json({ error: 'Media not found' });
      return;
    }
    console.error('[MediaProxy] S3 error:', err.message);
    res.status(500).json({ error: 'Failed to load media' });
  }
});

export { router as mediaRouter };
