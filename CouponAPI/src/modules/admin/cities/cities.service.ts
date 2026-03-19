import { prisma } from '../../../config/db';
import { ConflictError, NotFoundError } from '../../../shared/utils/AppError';
import type {
  CreateCityDto,
  UpdateCityDto,
  CreateAreaDto,
  UpdateAreaDto,
} from './cities.validator';

export class CitiesService {
  // ─── Cities ──────────────────────────────────────────────────────────────────

  async getCities() {
    return prisma.city.findMany({
      orderBy: { name: 'asc' },
      include: {
        _count: {
          select: { areas: true, users: true, sellers: true },
        },
      },
    });
  }

  async createCity(dto: CreateCityDto) {
    // Check for duplicate city name (case-insensitive)
    const existing = await prisma.city.findFirst({
      where: { name: { equals: dto.name, mode: 'insensitive' } },
    });
    if (existing) throw ConflictError('City with this name already exists');

    return prisma.city.create({ data: dto });
  }

  async updateCity(id: string, dto: UpdateCityDto) {
    const city = await prisma.city.findUnique({ where: { id } });
    if (!city) throw NotFoundError('City');

    if (dto.name && dto.name.toLowerCase() !== city.name.toLowerCase()) {
      const existing = await prisma.city.findFirst({
        where: { name: { equals: dto.name, mode: 'insensitive' } },
      });
      if (existing) throw ConflictError('City with this name already exists');
    }

    return prisma.city.update({
      where: { id },
      data: dto,
    });
  }

  // ─── Areas ───────────────────────────────────────────────────────────────────

  async getAreasByCity(cityId: string) {
    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    return prisma.area.findMany({
      where: { cityId },
      orderBy: { name: 'asc' },
    });
  }

  async createArea(cityId: string, dto: CreateAreaDto) {
    const city = await prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw NotFoundError('City');

    const existing = await prisma.area.findFirst({
      where: {
        cityId,
        name: { equals: dto.name, mode: 'insensitive' },
      },
    });
    if (existing) throw ConflictError('Area with this name already exists in this city');

    return prisma.area.create({
      data: {
        ...dto,
        cityId,
      },
    });
  }

  async updateArea(id: string, dto: UpdateAreaDto) {
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

    return prisma.area.update({
      where: { id },
      data: dto,
    });
  }
}
