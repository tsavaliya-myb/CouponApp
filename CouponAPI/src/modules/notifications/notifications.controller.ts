import { Request, Response, NextFunction } from 'express';
import { prisma } from '../../config/db';
import { sendSuccess } from '../../shared/utils/response';
import { oneSignal } from './onesignal.service';
import type { 
  SendNotificationBody,
  SendNotificationResponse,
  PaginatedNotificationHistoryResponse,
} from './notifications.validator';
import { AppError } from '../../shared/utils/AppError';

export class NotificationsController {

  send = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { targetType, targetId, title, body } = req.body as SendNotificationBody;
      let logId: string | null = null;

      if (targetType === 'USER' && targetId) {
        // Validate user existence natively
        const user = await prisma.user.findUnique({ where: { id: targetId } });
        if (!user) throw new AppError('User not found', 404);
        logId = await oneSignal.sendToUser(targetId, title, body, 'admin_manual');

      } else if (targetType === 'CITY' && targetId) {
        const city = await prisma.city.findUnique({ where: { id: targetId } });
        if (!city) throw new AppError('City not found', 404);
        logId = await oneSignal.sendToCity(targetId, title, body, 'admin_manual_city');

      } else {
        logId = await oneSignal.sendGlobally(title, body, 'admin_manual_global');
      }

      const responsePayload: SendNotificationResponse = { dispatched: true, logId };
      sendSuccess(res, responsePayload, 200);
    } catch (err) { next(err); }
  };

  getHistory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const logs = await prisma.notificationLog.findMany({
        skip: (page - 1) * limit,
        take: limit,
        orderBy: { sentAt: 'desc' },
      });

      const totalCount = await prisma.notificationLog.count();

      const responsePayload: PaginatedNotificationHistoryResponse = { data: logs, meta: { totalCount, page, limit } };
      sendSuccess(res, responsePayload, 200);
    } catch (err) { next(err); }
  };
}
