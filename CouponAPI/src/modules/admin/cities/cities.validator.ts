import { z } from 'zod';
import { CityStatus } from '@prisma/client';

// ─── City Schemas ─────────────────────────────────────────────────────────────

export const createCitySchema = z.object({
  name: z.string().min(1, 'City name is required').max(100),
  status: z.nativeEnum(CityStatus).optional(),
});

export const updateCitySchema = z.object({
  name: z.string().min(1).max(100).optional(),
  status: z.nativeEnum(CityStatus).optional(),
});

// ─── Area Schemas ─────────────────────────────────────────────────────────────

export const createAreaSchema = z.object({
  name: z.string().trim().min(1, 'Area name is required').max(100),
  isActive: z.boolean().optional(),
});

export const updateAreaSchema = z.object({
  name: z.string().trim().min(1).max(100).optional(),
  isActive: z.boolean().optional(),
});

// ─── Response Schemas ─────────────────────────────────────────────────────────

export const baseCityResponseSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  status: z.nativeEnum(CityStatus),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export const cityWithCountsResponseSchema = baseCityResponseSchema.extend({
  _count: z.object({
    areas: z.number(),
    users: z.number(),
    sellers: z.number(),
  }),
});

export const baseAreaResponseSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  cityId: z.string().uuid(),
  isActive: z.boolean(),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export type BaseCityResponse = z.infer<typeof baseCityResponseSchema>;
export type CityWithCountsResponse = z.infer<typeof cityWithCountsResponseSchema>;
export type BaseAreaResponse = z.infer<typeof baseAreaResponseSchema>;

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type CreateCityDto = z.infer<typeof createCitySchema>;
export type UpdateCityDto = z.infer<typeof updateCitySchema>;
export type CreateAreaDto = z.infer<typeof createAreaSchema>;
export type UpdateAreaDto = z.infer<typeof updateAreaSchema>;
