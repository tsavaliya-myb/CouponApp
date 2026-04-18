import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { prisma } from '../../config/db';
import { ONESIGNAL_API_URL } from '../../shared/constants';

type TargetType = 'USER' | 'CITY' | 'GLOBAL';

export class OneSignalService {
  private appId: string;
  private apiKey: string;

  constructor() {
    this.appId = env.ONESIGNAL_APP_ID || '';
    this.apiKey = env.ONESIGNAL_REST_API_KEY || '';
  }

  private async dispatch(payload: any, type: string, targetType: TargetType, targetId?: string) {
    if (!this.appId || !this.apiKey) {
      logger.warn('OneSignal not configured — skipping push notification');
      return null;
    }

    try {
      const response = await fetch(ONESIGNAL_API_URL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${this.apiKey}`,
        },
        body: JSON.stringify({
          app_id: this.appId,
          ...payload,
        }),
      });

      const data = (await response.json()) as any;

      if (!response.ok) {
        logger.error('OneSignal API Error', data);
        return null;
      }

      // Log the notification out to the DB asynchronously
      await prisma.notificationLog.create({
        data: {
          type,
          targetType,
          targetId,
          title: payload.headings?.en || 'Notification',
          body: payload.contents?.en || '',
          onesignalId: data.id,
        },
      }).catch(err => logger.error('Failed to log notification', { err: err.message }));

      return data.id;
    } catch (error) {
      logger.error('OneSignal Dispatch Error', error);
      return null;
    }
  }

  // Target a single user via OneSignal external_id (set via OneSignal.login(userId) in Flutter)
  async sendToUser(userId: string, title: string, body: string, logType: string = 'direct') {
    return this.dispatch({
      headings: { en: title },
      contents: { en: body },
      include_aliases: { external_id: [userId] },
      target_channel: 'push',
    }, logType, 'USER', userId);
  }

  // Target users in a city via cityId tag (set via OneSignal.User.addTags in Flutter)
  async sendToCity(cityId: string, title: string, body: string, logType: string = 'city_broadcast') {
    return this.dispatch({
      headings: { en: title },
      contents: { en: body },
      filters: [{ field: 'tag', key: 'cityId', relation: '=', value: cityId }],
    }, logType, 'CITY', cityId);
  }

  // Target a seller via external_id (seller Flutter app must call OneSignal.login(sellerId))
  async sendToSeller(sellerId: string, title: string, body: string, logType: string = 'seller_direct') {
    return this.dispatch({
      headings: { en: title },
      contents: { en: body },
      include_aliases: { external_id: [sellerId] },
      target_channel: 'push',
    }, logType, 'USER', sellerId);
  }

  // Global broadcast
  async sendGlobally(title: string, body: string, logType: string = 'global_broadcast') {
    return this.dispatch({
      headings: { en: title },
      contents: { en: body },
      included_segments: ['Subscribed Users'], // Target all active devices
    }, logType, 'GLOBAL');
  }
}

export const oneSignal = new OneSignalService();
