import { z } from 'zod';

// ─── Presign Schema ────────────────────────────────────────────────────────────

export const presignCategoryImageSchema = z.object({
  mimeType: z.string().regex(/^image\/(jpeg|png|webp|gif)$/, 'Must be a valid image MIME type'),
});

// ─── Create / Update Schemas ───────────────────────────────────────────────────

export const createCategorySchema = z.object({
  name: z.string().min(1).max(100),
  subtitle: z.string().max(100).optional(),
  imageUrl: z.string().url().optional(),
  sortOrder: z.number().int().optional(),
});

export const updateCategorySchema = z.object({
  name: z.string().min(1).max(100).optional(),
  subtitle: z.string().max(100).optional(),
  imageUrl: z.string().url().optional().nullable(),
  isActive: z.boolean().optional(),
  sortOrder: z.number().int().optional(),
});

export const reorderCategorySchema = z.object({
  orderedIds: z.array(z.string().uuid()),
});

// ─── Response Schema ───────────────────────────────────────────────────────────

export const categoryResponseSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  slug: z.string(),
  subtitle: z.string().nullable(),
  imageUrl: z.string().nullable(),
  sortOrder: z.number().int(),
  isActive: z.boolean(),
  createdAt: z.date().or(z.string()),
  updatedAt: z.date().or(z.string()),
});

export type PresignCategoryImageDto = z.infer<typeof presignCategoryImageSchema>;
export type CreateCategoryDto = z.infer<typeof createCategorySchema>;
export type UpdateCategoryDto = z.infer<typeof updateCategorySchema>;
export type CategoryResponse = z.infer<typeof categoryResponseSchema>;
