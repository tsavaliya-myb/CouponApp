import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getCities, getAreasByCity, createCity, updateCity, createArea, updateArea } from "@/services/location.service";

export const useCities = () => {
  return useQuery({
    queryKey: ["cities"],
    queryFn: getCities,
  });
};

export const useAreas = (cityId: string | null | undefined) => {
  return useQuery({
    queryKey: ["areas", cityId],
    queryFn: () => getAreasByCity(cityId as string),
    enabled: !!cityId,
  });
};

export const useCreateCity = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: { name: string; status: string }) => createCity(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["cities"] });
    }
  });
};

export const useUpdateCity = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, payload }: { id: string; payload: { name?: string; status?: string } }) => updateCity(id, payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["cities"] });
    }
  });
};

export const useCreateArea = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ cityId, payload }: { cityId: string; payload: { name: string; isActive: boolean } }) => createArea(cityId, payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ["areas", variables.cityId] });
      queryClient.invalidateQueries({ queryKey: ["cities"] });
    }
  });
};

export const useUpdateArea = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, payload }: { id: string; payload: { name?: string; isActive?: boolean } }) => updateArea(id, payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["areas"] });
    }
  });
};
