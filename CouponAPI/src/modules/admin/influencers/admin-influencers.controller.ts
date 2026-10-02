import { Request, Response, NextFunction } from 'express';
import { AdminInfluencersService } from './admin-influencers.service';

const service = new AdminInfluencersService();

export class AdminInfluencersController {
  
  listInfluencers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await service.listInfluencers(req.query);
      res.json({ success: true, ...result });
    } catch (err) { next(err); }
  };

  getInfluencer = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getInfluencer((req.params.id as string));
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  approveInfluencer = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.approveInfluencer((req.params.id as string));
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  suspendInfluencer = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.suspendInfluencer((req.params.id as string));
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  rejectInfluencer = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.rejectInfluencer((req.params.id as string));
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  editInfluencer = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.editInfluencer((req.params.id as string), req.body);
      res.json({ success: true, data });
    } catch (err) { next(err); }
  };

  listBookings = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await service.listAllBookings(req.query);
      res.json({ success: true, ...result });
    } catch (err) { next(err); }
  };
}
