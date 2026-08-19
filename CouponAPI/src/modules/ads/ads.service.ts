import { prisma } from '../../config/db';
import { NotFoundError } from '../../shared/utils/AppError';
import type {
  CreateBannerAdDto,
  UpdateBannerAdDto,
  AdminListAdsDto,
  PublicBannersDto,
} from './ads.validator';
import { s3Client, BUCKET_NAME, getPublicUrl, extractKeyFromProxyUrl } from '../../config/s3';
import { PutObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

// ─── Shared include shape ─────────────────────────────────────────────────────
const adInclude = {
  seller: { select: { id: true, businessName: true, phone: true } },
  cities: {
    include: {
      city: { select: { id: true, name: true } },
    },
  },
} as const;

export class AdsService {

  // ─── Admin: Create ────────────────────────────────────────────────────────────
  async createAd(dto: CreateBannerAdDto) {
    return prisma.bannerAd.create({
      data: {
        title:     dto.title,
        sellerId:  dto.sellerId ?? null,
        imageUrl:  dto.imageUrl ?? null,
        videoUrl:  dto.videoUrl ?? null,
        actionUrl: dto.actionUrl ?? null,
        startsAt:  new Date(dto.startsAt),
        endsAt:    new Date(dto.endsAt),
        status:    'ACTIVE',
        cities: {
          create: dto.cityIds.map((cityId) => ({
            id:     require('crypto').randomUUID(),
            cityId,
          })),
        },
      },
      include: adInclude,
    });
  }

  // ─── Admin: Update ────────────────────────────────────────────────────────────
  async updateAd(adId: string, dto: UpdateBannerAdDto) {
    const ad = await prisma.bannerAd.findUnique({ where: { id: adId } });
    if (!ad) throw NotFoundError('Ad not found');

    return prisma.$transaction(async (tx) => {
      // Delete old S3 media if a new one is provided or it's cleared
      if (dto.imageUrl !== undefined && ad.imageUrl && dto.imageUrl !== ad.imageUrl) {
        await this.deleteS3Object(ad.imageUrl);
      }
      if (dto.videoUrl !== undefined && ad.videoUrl && dto.videoUrl !== ad.videoUrl) {
        await this.deleteS3Object(ad.videoUrl);
      }

      // If new cityIds supplied, replace all city entries atomically
      if (dto.cityIds) {
        await tx.bannerAdCity.deleteMany({ where: { bannerAdId: adId } });
        await tx.bannerAdCity.createMany({
          data: dto.cityIds.map((cityId) => ({
            id:         require('crypto').randomUUID(),
            bannerAdId: adId,
            cityId,
          })),
        });
      }

      return tx.bannerAd.update({
        where: { id: adId },
        data: {
          ...(dto.title     !== undefined && { title:     dto.title }),
          ...(dto.sellerId  !== undefined && { sellerId:  dto.sellerId }),
          ...(dto.imageUrl  !== undefined && { imageUrl:  dto.imageUrl }),
          ...(dto.videoUrl  !== undefined && { videoUrl:  dto.videoUrl }),
          ...(dto.actionUrl !== undefined && { actionUrl: dto.actionUrl }),
          ...(dto.startsAt  !== undefined && { startsAt:  new Date(dto.startsAt) }),
          ...(dto.endsAt    !== undefined && { endsAt:    new Date(dto.endsAt) }),
          ...(dto.status    !== undefined && { status:    dto.status }),
        },
        include: adInclude,
      });
    });
  }

  // ─── Admin: Delete ────────────────────────────────────────────────────────────
  async deleteAd(adId: string) {
    const ad = await prisma.bannerAd.findUnique({ where: { id: adId } });
    if (!ad) throw NotFoundError('Ad not found');
    // Cascade deletes banner_ad_cities rows automatically
    await prisma.bannerAd.delete({ where: { id: adId } });
  }

  // ─── Admin: List ──────────────────────────────────────────────────────────────
  async adminListAds(dto: AdminListAdsDto) {
    const { status, sellerId, cityId, page, limit } = dto;

    const where: any = {};
    if (status)   where.status   = status;
    if (sellerId) where.sellerId = sellerId;
    if (cityId)   where.cities   = { some: { cityId } };

    const total = await prisma.bannerAd.count({ where });
    const skip  = (page - 1) * limit;

    const data = await prisma.bannerAd.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
      include: adInclude,
    });

    return {
      data,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  // ─── Admin: Get single ────────────────────────────────────────────────────────
  async adminGetAd(adId: string) {
    const ad = await prisma.bannerAd.findUnique({
      where: { id: adId },
      include: adInclude,
    });
    if (!ad) throw NotFoundError('Ad not found');
    return ad;
  }

  // ─── Admin: Pause ────────────────────────────────────────────────────────────
  async pauseAd(adId: string) {
    const ad = await prisma.bannerAd.findUnique({ where: { id: adId } });
    if (!ad) throw NotFoundError('Ad not found');
    return prisma.bannerAd.update({ where: { id: adId }, data: { status: 'PAUSED' } });
  }

  // ─── Admin: Resume ───────────────────────────────────────────────────────────
  async resumeAd(adId: string) {
    const ad = await prisma.bannerAd.findUnique({ where: { id: adId } });
    if (!ad) throw NotFoundError('Ad not found');
    return prisma.bannerAd.update({ where: { id: adId }, data: { status: 'ACTIVE' } });
  }

  // ─── Public: Active slider banners for a city ─────────────────────────────────
  async getActiveBanners(dto: PublicBannersDto) {
    const now = new Date();

    const ads = await prisma.bannerAd.findMany({
      where: {
        status:   'ACTIVE',
        startsAt: { lte: now },
        endsAt:   { gte: now },
        // If cityId provided: match ads that target this city
        // If no cityIds provided on the ad (global) — those won't appear unless we
        // explicitly handle it. We keep it simple: if cityId provided, return ads
        // that have at least one BannerAdCity entry for this city.
        ...(dto.cityId
          ? { cities: { some: { cityId: dto.cityId } } }
          : {}
        ),
      },
      orderBy: { createdAt: 'desc' },
      select: {
        id:        true,
        imageUrl:  true,
        videoUrl:  true,
        actionUrl: true,
        seller:    { select: { id: true, businessName: true } },
        cities:    { include: { city: { select: { id: true, name: true } } } },
      },
    });

    return ads;
  }

  // ─── Public: Impression / Click tracking (fire-and-forget) ───────────────────
  recordImpression(adId: string) {
    prisma.bannerAd.update({
      where: { id: adId },
      data:  { impressions: { increment: 1 } },
    }).catch(() => {});
  }

  recordClick(adId: string) {
    prisma.bannerAd.update({
      where: { id: adId },
      data:  { clicks: { increment: 1 } },
    }).catch(() => {});
  }

  // ─── Admin: Presigned URL for media upload ──────────────────────────────────
  async generatePresignedUploadUrl(
    mimeType: string,
  ): Promise<{ uploadUrl: string; fileKey: string; publicUrl: string }> {
    const ext = mimeType.split('/')[1];
    const fileKey = `banner-content/${Date.now()}-${crypto.randomUUID()}.${ext}`;
    const command = new PutObjectCommand({
      Bucket: BUCKET_NAME,
      Key: fileKey,
      ContentType: mimeType,
    });
    const uploadUrl = await getSignedUrl(s3Client, command, { expiresIn: 300 });
    return { uploadUrl, fileKey, publicUrl: getPublicUrl(fileKey) };
  }

  // ─── Delete S3 object by proxy URL ───────────────────────────────────────────
  private async deleteS3Object(fileUrl: string): Promise<void> {
    try {
      const key = extractKeyFromProxyUrl(fileUrl);
      if (!key) {
        console.warn('[AdsService] Could not extract key from URL:', fileUrl);
        return;
      }
      await s3Client.send(new DeleteObjectCommand({ Bucket: BUCKET_NAME, Key: key }));
    } catch (err: any) {
      console.error('[AdsService] Failed to delete S3 object:', err.message);
    }
  }
}
