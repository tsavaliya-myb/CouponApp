import { prisma } from '../../../config/db';
import { RedisCacheService } from '../../../shared/services/redisCache.service';
import { REDIS_KEYS } from '../../../shared/constants';

import type { AppSettingsResponse } from './settings.validator';

export class AppSettingsService {

  async getAllSettings(): Promise<AppSettingsResponse> {
    const cached = await RedisCacheService.getCache<AppSettingsResponse>(REDIS_KEYS.APP_SETTINGS);
    if (cached) return cached;

    const rawArgs = await prisma.appSetting.findMany();
    // Reduce array to a mapped object { key: value }
    const settingsMap = rawArgs.reduce((acc, current) => {
      acc[current.key] = current.value;
      return acc;
    }, {} as Record<string, string>);

    await RedisCacheService.setCache(REDIS_KEYS.APP_SETTINGS, settingsMap);
    return settingsMap;
  }

  async updateSettings(settingsMap: Record<string, string | number>): Promise<AppSettingsResponse> {
    // Perform upserts in a transaction cleanly
    const updates = Object.entries(settingsMap).map(([key, value]) => {
      return prisma.appSetting.upsert({
        where: { key },
        update: { value: String(value) },
        create: { key, value: String(value) }
      });
    });

    await prisma.$transaction(updates);

    // Invalidate cache
    await RedisCacheService.delCache(REDIS_KEYS.APP_SETTINGS);

    // Return the freshest map
    return this.getAllSettings();
  }
  
  // Internal helper function used broadly across other services
  async getSetting(key: string, defaultValue?: string): Promise<string> {
    const allSettings = await this.getAllSettings();
    return allSettings[key] ?? defaultValue ?? '';
  }
}

export const appSettingsService = new AppSettingsService();
