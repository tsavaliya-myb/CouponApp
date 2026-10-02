import { prisma } from '../../../config/db';
import { NotFoundError } from '../../../shared/utils/AppError';

export class AdminNichesService {
  
  async listNiches() {
    return prisma.influencerNiche.findMany({
      orderBy: { sortOrder: 'asc' },
      include: {
        _count: { select: { influencers: true } }
      }
    });
  }

  async createNiche(dto: any) {
    return prisma.influencerNiche.create({ data: dto });
  }

  async updateNiche(id: string, dto: any) {
    const niche = await prisma.influencerNiche.findUnique({ where: { id } });
    if (!niche) throw NotFoundError('Influencer Niche');
    return prisma.influencerNiche.update({ where: { id }, data: dto });
  }

  async deleteNiche(id: string) {
    return prisma.influencerNiche.delete({ where: { id } });
  }
}
