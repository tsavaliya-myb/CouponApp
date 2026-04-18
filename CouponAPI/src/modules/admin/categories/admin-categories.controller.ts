import { Request, Response, NextFunction } from 'express';
import { AdminCategoriesService } from './admin-categories.service';
import { sendSuccess, sendCreated } from '../../../shared/utils/response';

const service = new AdminCategoriesService();

export class AdminCategoriesController {

  listCategories = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const includeInactive = req.query.includeInactive === 'true';
      const categories = await service.listCategories(includeInactive);
      sendSuccess(res, categories);
    } catch (err) {
      next(err);
    }
  };

  createCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const category = await service.createCategory(req.body);
      sendCreated(res, category);
    } catch (err) {
      next(err);
    }
  };

  updateCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const category = await service.updateCategory(req.params.id as string, req.body);
      sendSuccess(res, category);
    } catch (err) {
      next(err);
    }
  };
}
