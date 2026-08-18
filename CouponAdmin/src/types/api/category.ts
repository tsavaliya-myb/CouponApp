export interface Category {
  id: string;
  name: string;
  slug: string;
  subtitle: string | null;
  imageUrl: string | null;
  isActive: boolean;
  sortOrder: number;
  createdAt: string;
  updatedAt: string;
}

export interface CreateCategoryRequest {
  name: string;
  subtitle?: string;
  imageUrl?: string;
}

export interface UpdateCategoryRequest {
  name?: string;
  subtitle?: string;
  imageUrl?: string | null;
  isActive?: boolean;
}

export interface PresignCategoryImageResponse {
  uploadUrl: string;
  fileKey: string;
  publicUrl: string;
}
