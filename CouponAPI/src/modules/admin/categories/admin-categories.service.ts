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
      orderBy: [{ sortOrder: 'asc' }, { name: 'asc' }],
    });

    const others = categories.filter(c => c.name.toLowerCase() === 'other');
    const nonOthers = categories.filter(c => c.name.toLowerCase() !== 'other');
    const finalCategories = [...nonOthers, ...others];

    await RedisCacheService.setCache(REDIS_KEYS.CATEGORIES_ALL, finalCategories, 24 * 60 * 60);
    return includeInactive ? finalCategories : finalCategories.filter(c => c.isActive);
  }

  async reorderCategories(orderedIds: string[]): Promise<void> {
    const transactions = orderedIds.map((id, index) => 
      prisma.category.update({
        where: { id },
        data: { sortOrder: index + 1 }
      })
    );
    await prisma.$transaction(transactions);
    await RedisCacheService.delCache(REDIS_KEYS.CATEGORIES_ALL);
  }

  async createCategory(dto: CreateCategoryDto): Promise<CategoryResponse> {
    const existingName = await prisma.category.findFirst({
      where: { name: { equals: dto.name, mode: 'insensitive' } },
    });
    if (existingName) throw ConflictError('Category with this name already exists');

    let slug = dto.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)+/g, '');
    if (!slug) slug = 'category-' + Date.now();

    const existingSlug = await prisma.category.findUnique({ where: { slug } });
    if (existingSlug) throw ConflictError('Category with this slug already exists. Please choose a different name.');

    const result = await prisma.category.create({ data: { ...dto, slug } });
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

    const result = await prisma.category.update({ where: { id }, data: dto });
    await RedisCacheService.delCache(REDIS_KEYS.CATEGORIES_ALL);
    return result;
  }
}
