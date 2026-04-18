import { prisma } from '../../../config/db';
import { ConflictError, NotFoundError } from '../../../shared/utils/AppError';
import { RedisCacheService } from '../../../shared/services/redisCache.service';
import { REDIS_KEYS } from '../../../shared/constants';
import type { CreateCategoryDto, UpdateCategoryDto, CategoryResponse } from './admin-categories.validator';

export class AdminCategoriesService {

  async listCategories(includeInactive = false): Promise<CategoryResponse[]> {
    const cached = await RedisCacheService.getCache<CategoryResponse[]>(REDIS_KEYS.CATEGORIES_ALL);
    if (cached && !includeInactive) return cached.filter(c => c.isActive);
    if (cached && includeInactive) return cached;

    const categories = await prisma.category.findMany({
      orderBy: { name: 'asc' },
    });

    await RedisCacheService.setCache(REDIS_KEYS.CATEGORIES_ALL, categories, 24 * 60 * 60);
    return includeInactive ? categories : categories.filter(c => c.isActive);
  }

  async createCategory(dto: CreateCategoryDto): Promise<CategoryResponse> {
    const existingName = await prisma.category.findFirst({
      where: { name: { equals: dto.name, mode: 'insensitive' } },
    });
    if (existingName) throw ConflictError('Category with this name already exists');

    const existingSlug = await prisma.category.findUnique({ where: { slug: dto.slug } });
    if (existingSlug) throw ConflictError('Category with this slug already exists');

    const result = await prisma.category.create({ data: dto });
    await RedisCacheService.delCache(REDIS_KEYS.CATEGORIES_ALL);
    return result;
  }

  async updateCategory(id: string, dto: UpdateCategoryDto): Promise<CategoryResponse> {
    const category = await prisma.category.findUnique({ where: { id } });
    if (!category) throw NotFoundError('Category');

    if (dto.name && dto.name.toLowerCase() !== category.name.toLowerCase()) {
      const existing = await prisma.category.findFirst({
        where: { name: { equals: dto.name, mode: 'insensitive' } },
      });
      if (existing) throw ConflictError('Category with this name already exists');
    }

    if (dto.slug && dto.slug !== category.slug) {
      const existing = await prisma.category.findUnique({ where: { slug: dto.slug } });
      if (existing) throw ConflictError('Category with this slug already exists');
    }

    const result = await prisma.category.update({ where: { id }, data: dto });
    await RedisCacheService.delCache(REDIS_KEYS.CATEGORIES_ALL);
    return result;
  }
}
