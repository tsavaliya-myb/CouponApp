import { Request, Response, NextFunction } from 'express';
import { CitiesService } from './cities.service';
import { sendSuccess, sendCreated } from '../../../shared/utils/response';

const citiesService = new CitiesService();

export class CitiesController {
  
  // ─── Cities ──────────────────────────────────────────────────────────────────

  getCities = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const cities = await citiesService.getCities();
      sendSuccess(res, cities);
    } catch (err) {
      next(err);
    }
  };

  createCity = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const city = await citiesService.createCity(req.body);
      sendCreated(res, city);
    } catch (err) {
      next(err);
    }
  };

  updateCity = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const city = await citiesService.updateCity(req.params.id as string, req.body);
      sendSuccess(res, city);
    } catch (err) {
      next(err);
    }
  };

  // ─── Areas ───────────────────────────────────────────────────────────────────

  getAreas = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const areas = await citiesService.getAreasByCity(req.params.cityId as string);
      sendSuccess(res, areas);
    } catch (err) {
      next(err);
    }
  };

  createArea = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const area = await citiesService.createArea(req.params.cityId as string, req.body);
      sendCreated(res, area);
    } catch (err) {
      next(err);
    }
  };

  updateArea = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const area = await citiesService.updateArea(req.params.id as string, req.body);
      sendSuccess(res, area);
    } catch (err) {
      next(err);
    }
  };
}
