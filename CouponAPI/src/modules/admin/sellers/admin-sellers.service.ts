import { prisma } from '../../../config/db';
import { NotFoundError } from '../../../shared/utils/AppError';
import { oneSignal } from '../../notifications/onesignal.service';
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
    const { page, limit, cityId, areaId, categoryId, status, search } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.SellerWhereInput = {};

    if (cityId) where.cityId = cityId;
    if (areaId) where.areaId = areaId;
    if (categoryId) (where as any).categoryId = categoryId;
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
          category: true,
          city: { select: { name: true } },
          area: { select: { name: true } },
        },
      }) as any,
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

    const updated = await prisma.seller.update({
      where: { id },
      data: { status: 'ACTIVE' },
    });

    oneSignal.sendToSeller(
      id,
      '✅ Account Approved!',
      `Your business "${seller.businessName}" has been approved. You can now receive coupon redemptions.`,
      'seller_approved',
    ).catch(() => {});

    return updated;
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

  // ─── Reject Seller ────────────────────────────────────────────────────────────
  async rejectSeller(id: string): Promise<BaseSellerResponse> {
    const seller = await prisma.seller.findUnique({ where: { id } });
    if (!seller) throw NotFoundError('Seller');

    return prisma.seller.update({
      where: { id },
      data: { status: 'REJECTED' },
    });
  }

  // ─── Edit Seller Details ──────────────────────────────────────────────────────
  async editSeller(id: string, dto: AdminUpdateSellerDto): Promise<SellerWithLocationResponse> {
    const seller = await prisma.seller.findUnique({ where: { id } });
    if (!seller) throw NotFoundError('Seller');

    return prisma.seller.update({
      where: { id },
      data: dto as any,
      include: {
        category: true,
        city: { select: { name: true } },
        area: { select: { name: true } },
      },
    }) as any;
  }
}
