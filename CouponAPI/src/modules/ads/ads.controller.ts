import { Request, Response, NextFunction } from 'express';
import { AdsService } from './ads.service';
import { sendSuccess } from '../../shared/utils/response';
import { logger } from '../../config/logger';
import type {
  CreateBannerAdDto,
  UpdateBannerAdDto,
  AdminListAdsDto,
  PublicBannersDto,
} from './ads.validator';

const adsService = new AdsService();
const log = logger.child({ module: 'AdsController' });

/** Narrows Express's `string | string[]` param type to plain string. */
const p = (req: Request, key: string): string => req.params[key] as string;

export class AdsController {

  // ─── Admin ────────────────────────────────────────────────────────────────────

  createAd = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ad = await adsService.createAd(req.body as CreateBannerAdDto);
      sendSuccess(res, ad, 201);
    } catch (err) {
      log.error('createAd error', { err });
      next(err);
    }
  };

  updateAd = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ad = await adsService.updateAd(p(req, 'id'), req.body as UpdateBannerAdDto);
      sendSuccess(res, ad);
    } catch (err) {
      next(err);
    }
  };

  deleteAd = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await adsService.deleteAd(p(req, 'id'));
      sendSuccess(res, { message: 'Ad deleted' });
    } catch (err) {
      next(err);
    }
  };

  adminListAds = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await adsService.adminListAds(req.query as unknown as AdminListAdsDto);
      res.status(200).json({ success: true, data: result.data, meta: result.meta });
    } catch (err) {
      next(err);
    }
  };

  adminGetAd = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ad = await adsService.adminGetAd(p(req, 'id'));
      sendSuccess(res, ad);
    } catch (err) {
      next(err);
    }
  };

  pauseAd = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ad = await adsService.pauseAd(p(req, 'id'));
      sendSuccess(res, ad);
    } catch (err) {
      next(err);
    }
  };

  resumeAd = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ad = await adsService.resumeAd(p(req, 'id'));
      sendSuccess(res, ad);
    } catch (err) {
      next(err);
    }
  };

  // ─── Public ───────────────────────────────────────────────────────────────────

  getActiveBanners = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ads = await adsService.getActiveBanners(req.query as unknown as PublicBannersDto);
      sendSuccess(res, ads);
    } catch (err) {
      next(err);
    }
  };

  recordImpression = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      adsService.recordImpression(p(req, 'id'));
      res.status(204).send();
    } catch (err) {
      next(err);
    }
  };

  recordClick = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      adsService.recordClick(p(req, 'id'));
      res.status(204).send();
    } catch (err) {
      next(err);
    }
  };
}
