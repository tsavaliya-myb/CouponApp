import { PaginatedMeta } from "./users";

export type BannerAdStatus = "ACTIVE" | "PAUSED" | "COMPLETED";

export interface BannerAdCity {
  id: string;
  cityId: string;
  city: { id: string; name: string };
}

export interface BannerAd {
  id: string;
  title: string;
  sellerId: string | null;
  seller: { id: string; businessName: string; phone: string } | null;
  imageUrl: string | null;
  videoUrl: string | null;
  actionUrl: string | null;
  status: BannerAdStatus;
  impressions: number;
  clicks: number;
  startsAt: string;
  endsAt: string;
  createdAt: string;
  cities: BannerAdCity[];
}

export interface BannerAdsResponse {
  success: boolean;
  data: BannerAd[];
  meta: PaginatedMeta;
}

export interface BannerAdResponse {
  success: boolean;
  data: BannerAd;
}

export interface CreateBannerAdPayload {
  title: string;
  sellerId?: string;
  imageUrl?: string;
  videoUrl?: string;
  actionUrl?: string;
  cityIds: string[];
  startsAt: string; // ISO datetime
  endsAt: string;   // ISO datetime
}

export interface UpdateBannerAdPayload {
  title?: string;
  sellerId?: string | null;
  imageUrl?: string | null;
  videoUrl?: string | null;
  actionUrl?: string | null;
  cityIds?: string[];
  startsAt?: string;
  endsAt?: string;
  status?: BannerAdStatus;
}

export interface GetBannerAdsParams {
  status?: BannerAdStatus;
  sellerId?: string;
  cityId?: string;
  page?: number;
  limit?: number;
}
