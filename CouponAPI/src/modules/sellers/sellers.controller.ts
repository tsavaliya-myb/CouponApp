import { Request, Response, NextFunction } from 'express';
import { SellersService } from './sellers.service';
import { sendSuccess, sendCreated } from '../../shared/utils/response';
import { verifyRegistrationToken } from '../../shared/utils/jwt';
import { UnauthorizedError, BadRequestError } from '../../shared/utils/AppError';
import { env } from '../../config/env';
import type { FindSellersDto, GetSellersByAreaCategoryDto } from './sellers.validator';
import fs from 'fs/promises';
import path from 'path';

const deleteOldMediaFile = async (oldUrl: string) => {
  try {
    const urlObj = new URL(oldUrl);
    // In dev: e.g. /uploads/sellers/logos/filename.jpg
    const publicPath = path.join(__dirname, '../../../../public');
    const filePath = path.join(publicPath, urlObj.pathname);
    await fs.unlink(filePath);
  } catch (err: any) {
    if (err.code !== 'ENOENT') {
      console.error('Failed to delete old media file:', err.message);
    }
  }
};

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

  uploadLogo = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      if (!req.file) {
        throw BadRequestError('Logo file is required');
      }

      const sellerId = req.user!.userId;
      const existingProfile = await sellersService.getProfile(sellerId);

      const filePath = `/uploads/sellers/logos/${req.file.filename}`;
      const serverUrl = 'https://couponapp-r1vv.onrender.com';
      const logoUrl = `${serverUrl}${filePath}`;

      const media = await sellersService.updateSellerLogo(sellerId, logoUrl);

      if (existingProfile.media?.logoUrl) {
        deleteOldMediaFile(existingProfile.media.logoUrl);
      }

      sendSuccess(res, media);
    } catch (err) {
      next(err);
    }
  };

  uploadMedia = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const files = req.files as { [fieldname: string]: Express.Multer.File[] };
      if (!files) {
        throw BadRequestError('At least one media file is required (photo1, photo2, or video)');
      }

      const sellerId = req.user!.userId;
      const existingProfile = await sellersService.getProfile(sellerId);

      const serverUrl = 'https://couponapp-r1vv.onrender.com';
      const updateData: { photoUrl1?: string; photoUrl2?: string; videoUrl?: string } = {};

      if (files['photo1'] && files['photo1'][0]) {
        updateData.photoUrl1 = `${serverUrl}/uploads/sellers/media/${files['photo1'][0].filename}`;
      }
      if (files['photo2'] && files['photo2'][0]) {
        updateData.photoUrl2 = `${serverUrl}/uploads/sellers/media/${files['photo2'][0].filename}`;
      }
      if (files['video'] && files['video'][0]) {
        updateData.videoUrl = `${serverUrl}/uploads/sellers/media/${files['video'][0].filename}`;
      }

      const media = await sellersService.updateSellerMediaFiles(sellerId, updateData);

      if (updateData.photoUrl1 && existingProfile.media?.photoUrl1) {
        deleteOldMediaFile(existingProfile.media.photoUrl1);
      }
      if (updateData.photoUrl2 && existingProfile.media?.photoUrl2) {
        deleteOldMediaFile(existingProfile.media.photoUrl2);
      }
      if (updateData.videoUrl && existingProfile.media?.videoUrl) {
        deleteOldMediaFile(existingProfile.media.videoUrl);
      }

      sendSuccess(res, media);
    } catch (err) {
      next(err);
    }
  };

  // ─── Customer-facing endpoint ───────────────────────────────────────────────
  findSellers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as FindSellersDto;
      const sellers = await sellersService.findSellersNearUser(query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };

  getSellersByAreaCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query as unknown as GetSellersByAreaCategoryDto;
      const sellers = await sellersService.getSellersByAreaCategory(query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };
}
