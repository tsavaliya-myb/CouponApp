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

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type CreateCityDto = z.infer<typeof createCitySchema>;
export type UpdateCityDto = z.infer<typeof updateCitySchema>;
export type CreateAreaDto = z.infer<typeof createAreaSchema>;
export type UpdateAreaDto = z.infer<typeof updateAreaSchema>;
