import { redis } from '../../config/redis';
import { logger } from '../../config/logger';

export class RedisCacheService {
  /**
   * Set a value in the Redis cache.
   * @param key The unique cache key.
   * @param value The value to cache (will be JSON stringified).
   * @param ttlSeconds Optional time-to-live in seconds. If not provided, caches indefinitely.
   */
  static async setCache(key: string, value: any, ttlSeconds?: number): Promise<void> {
    try {
      const stringifiedValue = JSON.stringify(value);
      if (ttlSeconds) {
        await redis.set(key, stringifiedValue, 'EX', ttlSeconds);
      } else {
        await redis.set(key, stringifiedValue);
      }
    } catch (error) {
      logger.error(`[RedisCacheService] Failed to set cache for key: ${key}`, { error });
    }
  }

  /**
   * Get a value from the Redis cache.
   * @param key The cache key.
   * @returns The parsed value, or null if not found or on error.
   */
  static async getCache<T>(key: string): Promise<T | null> {
    try {
      const data = await redis.get(key);
      if (!data) return null;
      return JSON.parse(data) as T;
    } catch (error) {
      logger.error(`[RedisCacheService] Failed to get cache for key: ${key}`, { error });
      return null;
    }
  }

  /**
   * Delete a value (or values) from the Redis cache.
   * @param keys A single key or an array of keys to delete.
   */
  static async delCache(keys: string | string[]): Promise<void> {
    try {
      const keysArray = Array.isArray(keys) ? keys : [keys];
      if (keysArray.length > 0) {
        await redis.del(...keysArray);
      }
    } catch (error) {
      logger.error(`[RedisCacheService] Failed to delete cache for keys: ${keys}`, { error });
    }
  }
}
