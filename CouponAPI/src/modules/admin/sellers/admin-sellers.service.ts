import { prisma } from '../../../config/db';
import { NotFoundError } from '../../../shared/utils/AppError';
import type { 
  AdminSellersQueryDto, 
  AdminUpdateSellerDto,
  PaginatedSellersResponse,
  BaseSellerResponse,
  SellerWithLocationResponse,
} from './admin-sellers.validator';
import { Prisma } from '@prisma/client';

export class AdminSellersService {
  
  // ─── List Sellers ─────────────────────────────────────────────────────────────
  async listSellers(query: AdminSellersQueryDto): Promise<PaginatedSellersResponse> {
    const { page, limit, cityId, areaId, category, status, search } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.SellerWhereInput = {};

    if (cityId) where.cityId = cityId;
    if (areaId) where.areaId = areaId;
    if (category) where.category = category;
    if (status) where.status = status;
    if (search) {
      where.OR = [
        { businessName: { contains: search, mode: 'insensitive' } },
        { phone: { contains: search } },
      ];
    }

    const [sellers, total] = await Promise.all([
      prisma.seller.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          city: { select: { name: true } },
          area: { select: { name: true } },
        },
      }),
      prisma.seller.count({ where }),
    ]);

    return {
      data: sellers,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  // ─── Approve Seller ───────────────────────────────────────────────────────────
  async approveSeller(id: string): Promise<BaseSellerResponse> {
    const seller = await prisma.seller.findUnique({ where: { id } });
    if (!seller) throw NotFoundError('Seller');

    return prisma.seller.update({
      where: { id },
      data: { status: 'ACTIVE' },
    });
  }

  // ─── Suspend Seller ───────────────────────────────────────────────────────────
  async suspendSeller(id: string): Promise<BaseSellerResponse> {
    const seller = await prisma.seller.findUnique({ where: { id } });
    if (!seller) throw NotFoundError('Seller');

    return prisma.seller.update({
      where: { id },
      data: { status: 'SUSPENDED' },
    });
  }

  // ─── Edit Seller Details ──────────────────────────────────────────────────────
  async editSeller(id: string, dto: AdminUpdateSellerDto): Promise<SellerWithLocationResponse> {
    const seller = await prisma.seller.findUnique({ where: { id } });
    if (!seller) throw NotFoundError('Seller');

    return prisma.seller.update({
      where: { id },
      data: dto,
      include: {
        city: { select: { name: true } },
        area: { select: { name: true } },
      },
    });
  }
}
