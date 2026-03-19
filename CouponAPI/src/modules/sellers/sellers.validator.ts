import { z } from 'zod';
import { SellerCategory } from '@prisma/client';

// ─── Seller Registration ──────────────────────────────────────────────────────
export const registerSellerSchema = z.object({
  phone: z.string().regex(/^[0-9]{10}$/, 'Phone number must be exactly 10 digits'),
  businessName: z.string().min(2, 'Business name is required').max(150),
  category: z.nativeEnum(SellerCategory).optional(),
  cityId: z.string().uuid('Invalid City ID'),
  areaId: z.string().uuid('Invalid Area ID'),
  upiId: z.string().max(100).optional(),
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
});

// ─── Seller Profile Update ────────────────────────────────────────────────────
export const updateSellerSchema = z.object({
  businessName: z.string().min(2).max(150).optional(),
  category: z.nativeEnum(SellerCategory).optional(),
  cityId: z.string().uuid().optional(),
  areaId: z.string().uuid().optional(),
  upiId: z.string().max(100).optional(),
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
});

// ─── Customer View: Find Sellers API ──────────────────────────────────────────
export const findSellersSchema = z.object({
  lat: z.coerce.number().min(-90).max(90),
  lng: z.coerce.number().min(-180).max(180),
  cityId: z.string().uuid().optional(), // Optionally restrict to a specific city
  limit: z.coerce.number().min(1).max(100).default(20),
});

// ─── Inferred Types ───────────────────────────────────────────────────────────
export type RegisterSellerDto = z.infer<typeof registerSellerSchema>;
export type UpdateSellerDto = z.infer<typeof updateSellerSchema>;
export type FindSellersDto = z.infer<typeof findSellersSchema>;
