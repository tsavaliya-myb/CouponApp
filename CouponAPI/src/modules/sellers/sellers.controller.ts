import { Request, Response, NextFunction } from 'express';
import { SellersService } from './sellers.service';
import { sendSuccess, sendCreated } from '../../shared/utils/response';
import { verifyRegistrationToken } from '../../shared/utils/jwt';
import { UnauthorizedError } from '../../shared/utils/AppError';
import type { FindSellersDto, GetSellersByCityCategoryDto } from './sellers.validator';

const sellersService = new SellersService();

export class SellersController {

  register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader?.startsWith('Bearer ')) {
        throw UnauthorizedError('No registration token provided');
      }
      const token = authHeader.split(' ')[1];
      const { phone } = verifyRegistrationToken(token);
      const result = await sellersService.register(phone, req.body);
      sendCreated(res, result);
    } catch (err) {
      next(err);
    }
  };

  getProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const profile = await sellersService.getProfile(req.user!.userId);
      sendSuccess(res, profile);
    } catch (err) {
      next(err);
    }
  };

  updateProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const updatedProfile = await sellersService.updateProfile(req.user!.userId, req.body);
      sendSuccess(res, updatedProfile);
    } catch (err) {
      next(err);
    }
  };

  getDashboard = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const dbInfo = await sellersService.getDashboard(req.user!.userId);
      sendSuccess(res, dbInfo);
    } catch (err) {
      next(err);
    }
  };

  // ─── Logo: Presign ────────────────────────────────────────────────────────────
  presignLogo = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { mimeType } = req.body as { mimeType: string };
      const result = await sellersService.generatePresignedUploadUrl('logos', mimeType);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };

  // ─── Logo: Confirm ────────────────────────────────────────────────────────────
  confirmLogo = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const sellerId = req.user!.userId;
      const { fileKey } = req.body as { fileKey: string };

      const existingProfile = await sellersService.getProfile(sellerId);
      const logoUrl = (await import('../../config/s3')).getPublicUrl(fileKey);

      const media = await sellersService.updateSellerLogo(sellerId, logoUrl);

      // Delete old logo from S3 if exists
      if (existingProfile.media?.logoUrl) {
        sellersService.deleteS3Object(existingProfile.media.logoUrl);
      }

      sendSuccess(res, media);
    } catch (err) {
      next(err);
    }
  };

  // ─── Media: Presign ───────────────────────────────────────────────────────────
  presignMedia = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { photo1MimeType, photo2MimeType, videoMimeType } = req.body as {
        photo1MimeType?: string;
        photo2MimeType?: string;
        videoMimeType?: string;
      };

      const result: Record<string, { uploadUrl: string; fileKey: string; publicUrl: string }> = {};

      if (photo1MimeType) {
        result.photo1 = await sellersService.generatePresignedUploadUrl('photos', photo1MimeType);
      }
      if (photo2MimeType) {
        result.photo2 = await sellersService.generatePresignedUploadUrl('photos', photo2MimeType);
      }
      if (videoMimeType) {
        result.video = await sellersService.generatePresignedUploadUrl('videos', videoMimeType);
      }

      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  };

  // ─── Media: Confirm ───────────────────────────────────────────────────────────
  confirmMedia = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const sellerId = req.user!.userId;
      const { photo1Key, photo2Key, videoKey } = req.body as {
        photo1Key?: string;
        photo2Key?: string;
        videoKey?: string;
      };

      const { getPublicUrl } = await import('../../config/s3');
      const existingProfile = await sellersService.getProfile(sellerId);

      const updateData: { photoUrl1?: string; photoUrl2?: string; videoUrl?: string } = {};

      if (photo1Key) updateData.photoUrl1 = getPublicUrl(photo1Key);
      if (photo2Key) updateData.photoUrl2 = getPublicUrl(photo2Key);
      if (videoKey) updateData.videoUrl = getPublicUrl(videoKey);

      const media = await sellersService.updateSellerMediaFiles(sellerId, updateData);

      // Delete old files from S3
      if (photo1Key && existingProfile.media?.photoUrl1) {
        sellersService.deleteS3Object(existingProfile.media.photoUrl1);
      }
      if (photo2Key && existingProfile.media?.photoUrl2) {
        sellersService.deleteS3Object(existingProfile.media.photoUrl2);
      }
      if (videoKey && existingProfile.media?.videoUrl) {
        sellersService.deleteS3Object(existingProfile.media.videoUrl);
      }

      sendSuccess(res, media);
    } catch (err) {
      next(err);
    }
  };

  // ─── Customer-facing endpoints ────────────────────────────────────────────────
  findSellers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as FindSellersDto;
      const sellers = await sellersService.findSellersNearUser(query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };

  getSellersByCityCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as GetSellersByCityCategoryDto;
      const sellers = await sellersService.getSellersByCityCategory(query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };

  getSellerMedia = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { sellerId } = req.body;
      const media = await sellersService.getSellerMedia(sellerId);
      sendSuccess(res, media);
    } catch (err) {
      next(err);
    }
  };
}
