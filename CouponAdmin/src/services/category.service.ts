import { apiClient } from '@/lib/apiClient';
import { Category, CreateCategoryRequest, UpdateCategoryRequest } from '../types/api/category';

export const CategoryService = {
  getAll: async (): Promise<Category[]> => {
    const response = await apiClient.get('/admin/categories');
    return response.data.data;
  },

  create: async (data: CreateCategoryRequest): Promise<Category> => {
    const response = await apiClient.post('/admin/categories', data);
    return response.data.data;
  },

  update: async (id: string, data: UpdateCategoryRequest): Promise<Category> => {
    const response = await apiClient.patch(`/admin/categories/${id}`, data);
    return response.data.data;
  },

  reorder: async (orderedIds: string[]): Promise<void> => {
    const response = await apiClient.patch('/admin/categories/reorder', { orderedIds });
    return response.data.data;
  },
};
