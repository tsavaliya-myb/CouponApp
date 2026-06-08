import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { CategoryService } from '../../services/category.service';
import { CreateCategoryRequest, UpdateCategoryRequest } from '../../types/api/category';
import { useToast } from '../use-toast';

export const useCategories = () => {
  return useQuery({
    queryKey: ['categories'],
    queryFn: CategoryService.getAll,
  });
};

export const useCreateCategory = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: (data: CreateCategoryRequest) => CategoryService.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['categories'] });
      toast({
        title: 'Success',
        description: 'Category created successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to create category',
        variant: 'destructive',
      });
    },
  });
};

export const useUpdateCategory = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateCategoryRequest }) =>
      CategoryService.update(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['categories'] });
      toast({
        title: 'Success',
        description: 'Category updated successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to update category',
        variant: 'destructive',
      });
    },
  });
};

export const useReorderCategories = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: (orderedIds: string[]) => CategoryService.reorder(orderedIds),
    onMutate: async (orderedIds) => {
      await queryClient.cancelQueries({ queryKey: ['categories'] });
      const previousCategories = queryClient.getQueryData(['categories']);
      
      queryClient.setQueryData(['categories'], (old: any) => {
        if (!old) return old;
        const newArray = [...old];
        newArray.sort((a, b) => {
          const indexA = orderedIds.indexOf(a.id);
          const indexB = orderedIds.indexOf(b.id);
          if (indexA === -1 || indexB === -1) return 0;
          return indexA - indexB;
        });
        return newArray;
      });

      return { previousCategories };
    },
    onError: (err, newOrder, context) => {
      queryClient.setQueryData(['categories'], context?.previousCategories);
      toast({
        title: 'Error',
        description: 'Failed to reorder categories',
        variant: 'destructive',
      });
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['categories'] });
    },
  });
};
