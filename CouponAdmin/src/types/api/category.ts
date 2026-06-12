export interface Category {
  id: string;
  name: string;
  slug: string;
  subtitle: string | null;
  color: string | null;
  iconName: string | null;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CreateCategoryRequest {
  name: string;
  subtitle?: string;
  color?: string;
  iconName?: string;
}

export interface UpdateCategoryRequest {
  name?: string;
  subtitle?: string;
  color?: string;
  iconName?: string;
  isActive?: boolean;
}
