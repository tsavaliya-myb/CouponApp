import { Request, Response, NextFunction } from 'express';
import { InfluencersService } from './influencers.service';

const service = new InfluencersService();

export class InfluencersController {
  
  register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { phone } = req.user!;
      const result = await service.register(phone as string, req.body);
      res.status(201).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  getProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getProfile(req.user!.userId);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  updateProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.updateProfile(req.user!.userId, req.body);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  getDashboard = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getDashboard(req.user!.userId);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  getMyServices = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getMyServices(req.user!.userId);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  addService = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.addService(req.user!.userId, req.body);
      res.status(201).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  updateService = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.updateService(req.user!.userId, (req.params.id as string), req.body);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  toggleServiceStatus = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.toggleServiceStatus(req.user!.userId, (req.params.id as string));
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  deleteService = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await service.deleteService(req.user!.userId, (req.params.id as string));
      res.json({ success: true, message: 'Service deleted successfully' });
    } catch (err) {
      next(err);
    }
  };

  findInfluencers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await service.findInfluencers(req.query as any);
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  };

  getPublicProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getInfluencerPublicProfile((req.params.id as string));
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  getActiveNiches = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getActiveNiches();
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  createBooking = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      // Influencer is determined by the serviceId inside req.body
      const data = await service.createBooking(req.user!.userId, req.body);
      res.status(201).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  updateBookingStatus = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.updateBookingStatus(req.user!.userId, (req.params.id as string), req.body);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  getMyIncomingBookings = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getMyIncomingBookings(req.user!.userId);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  getUserBookings = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const data = await service.getUserBookings(req.user!.userId);
      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };
}
