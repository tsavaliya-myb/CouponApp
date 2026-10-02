import { z } from 'zod';

export const createNicheSchema = z.object({
  name: z.string().min(2).max(100),
  slug: z.string().min(2).max(100),
  iconName: z.string().optional().nullable(),
  color: z.string().regex(/^#[0-9a-fA-F]{6}$/).optional().nullable(),
  isActive: z.boolean().optional(),
  sortOrder: z.number().int().optional(),
});

export const updateNicheSchema = createNicheSchema.partial();
