import { Request, Response, NextFunction } from 'express';
import { appSettingsService } from './settings.service';
import { sendSuccess } from '../../../shared/utils/response';
import type { UpdateSettingsBody } from './settings.validator';

export class AppSettingsController {

  getAll = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const settings = await appSettingsService.getAllSettings();
      sendSuccess(res, settings);
    } catch (err) { next(err); }
  };

  updateBatch = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const settings = req.body as UpdateSettingsBody;
      const updated = await appSettingsService.updateSettings(settings);
      sendSuccess(res, updated);
    } catch (err) { next(err); }
  };
}
