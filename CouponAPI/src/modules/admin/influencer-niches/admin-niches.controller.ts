import { Request, Response, NextFunction } from 'express';
import { AdminNichesService } from './admin-niches.service';

const service = new AdminNichesService();

export class AdminNichesController {
  
  list = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.listNiches();
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  create = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.createNiche(req.body);
      res.status(201).json({ success: true, data });
    } catch (err) { next(err); }
  };

  update = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.updateNiche((req.params.id as string), req.body);
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  delete = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await service.deleteNiche((req.params.id as string));
      res.json({ success: true, message: 'Niche deleted' });
    } catch (err) { next(err); }
  };
}
