import { prisma } from '../../../config/db';
import { ConflictError, NotFoundError } from '../../../shared/utils/AppError';
import { RedisCacheService } from '../../../shared/services/redisCache.service';
import { REDIS_KEYS } from '../../../shared/constants';
import type {
  CreateCityDto,
  UpdateCityDto,
  CreateAreaDto,
  UpdateAreaDto,
  BaseCityResponse,
  CityWithCountsResponse,
  BaseAreaResponse,
} from './cities.validator';

export class CitiesService {
  private getDistanceFromLatLonInKm(lat1: number, lon1: number, lat2: number, lon2: number) {
    const R = 6371; // Radius of the earth in km
    const dLat = (lat2 - lat1) * (Math.PI / 180);
    const dLon = (lon2 - lon1) * (Math.PI / 180);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private async recalculateAreaDistances(area: { id: string, cityId: string, latitude: number | null, longitude: number | null }) {
    if (area.latitude === null || area.longitude === null) return;

    const otherAreas = await prisma.area.findMany({
      where: {
        cityId: area.cityId,
        id: { not: area.id },
        latitude: { not: null },
        longitude: { not: null },
      }
    });

    for (const other of otherAreas) {
      const distance = this.getDistanceFromLatLonInKm(area.latitude, area.longitude, other.latitude!, other.longitude!);
      
      // Upsert area -> other
      await prisma.areaDistance.upsert({
        where: { fromAreaId_toAreaId: { fromAreaId: area.id, toAreaId: other.id } },
        update: { distanceKm: distance },
        create: { fromAreaId: area.id, toAreaId: other.id, distanceKm: distance }
      });

      // Upsert other -> area
      await prisma.areaDistance.upsert({
        where: { fromAreaId_toAreaId: { fromAreaId: other.id, toAreaId: area.id } },
        update: { distanceKm: distance },
        create: { fromAreaId: other.id, toAreaId: area.id, distanceKm: distance }
      });
    }

    // Distance to itself is 0
    await prisma.areaDistance.upsert({
      where: { fromAreaId_toAreaId: { fromAreaId: area.id, toAreaId: area.id } },
      update: { distanceKm: 0 },
      create: { fromAreaId: area.id, toAreaId: area.id, distanceKm: 0 }
    });
  }

  // ─── Cities ──────────────────────────────────────────────────────────────────

  async getCities(): Promise<CityWithCountsResponse[]> {
    const cached = await RedisCacheService.getCache<any>(REDIS_KEYS.CITIES_ALL);
    if (cached) return cached;

    const cities = await prisma.city.findMany({
      orderBy: { name: 'asc' },
      include: {
        _count: {
          select: { areas: true, users: true, sellers: true },
        },
      },
    });

    await RedisCacheService.setCache(REDIS_KEYS.CITIES_ALL, cities, 24 * 60 * 60); // 24h
    return cities;
  }

  async createCity(dto: CreateCityDto): Promise<BaseCityResponse> {
    // Check for duplicate city name (case-insensitive)
    const existing = await prisma.city.findFirst({
      where: { name: { equals: dto.name, mode: 'insensitive' } },
    });
    if (existing) throw ConflictError('City with this name already exists');

    const result = await prisma.city.create({ data: dto });
    await RedisCacheService.delCache(REDIS_KEYS.CITIES_ALL);
    return result;
  }

  async updateCity(id: string, dto: UpdateCityDto): Promise<BaseCityResponse> {
    const city = await prisma.city.findUnique({ where: { id } });
    if (!city) throw NotFoundError('City');

    if (dto.name && dto.name.toLowerCase() !== city.name.toLowerCase()) {
      const existing = await prisma.city.findFirst({
        where: { name: { equals: dto.name, mode: 'insensitive' } },
      });
      if (existing) throw ConflictError('City with this name already exists');
    }

    const result = await prisma.city.update({
      where: { id },
      data: dto,
    });
    await RedisCacheService.delCache(REDIS_KEYS.CITIES_ALL);
    return result;
  }

  // ─── Areas ───────────────────────────────────────────────────────────────────

  async getAreasByCity(cityId: string): Promise<BaseAreaResponse[]> {
    const cacheKey = REDIS_KEYS.CITY_AREAS(cityId);
    const cached = await RedisCacheService.getCache<any>(cacheKey);
    if (cached) return cached;

    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    const areas = await prisma.area.findMany({
      where: { cityId },
      orderBy: { name: 'asc' },
    });

    await RedisCacheService.setCache(cacheKey, areas, 24 * 60 * 60); // 24h
    return areas;
  }

  async createArea(cityId: string, dto: CreateAreaDto): Promise<BaseAreaResponse> {
    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    const existing = await prisma.area.findFirst({
      where: {
        cityId,
        name: { equals: dto.name, mode: 'insensitive' },
      },
    });
    if (existing) throw ConflictError('Area with this name already exists in this city');

    const result = await prisma.area.create({
      data: {
        ...dto,
        cityId,
      },
    });

    if (result.latitude && result.longitude) {
      await this.recalculateAreaDistances(result);
    }

    await RedisCacheService.delCache([REDIS_KEYS.CITIES_ALL, REDIS_KEYS.CITY_AREAS(cityId)]);
    return result;
  }

  async updateArea(id: string, dto: UpdateAreaDto): Promise<BaseAreaResponse> {
    const area = await prisma.area.findUnique({ where: { id } });
    if (!area) throw NotFoundError('Area');

    if (dto.name && dto.name.toLowerCase() !== area.name.toLowerCase()) {
      const existing = await prisma.area.findFirst({
        where: {
          cityId: area.cityId,
          name: { equals: dto.name, mode: 'insensitive' },
        },
      });
      if (existing) throw ConflictError('Area with this name already exists in this city');
    }

    const result = await prisma.area.update({
      where: { id },
      data: dto,
    });

    if (dto.latitude !== undefined || dto.longitude !== undefined) {
      if (result.latitude && result.longitude) {
        await this.recalculateAreaDistances(result);
      }
    }

    await RedisCacheService.delCache([REDIS_KEYS.CITIES_ALL, REDIS_KEYS.CITY_AREAS(area.cityId)]);
    return result;
  }
}
