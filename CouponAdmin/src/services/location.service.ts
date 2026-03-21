import { apiClient } from "@/lib/apiClient";
import { CitiesResponse, AreasResponse, CityResponse, AreaResponse } from "@/types/api/location";

export const getCities = async (): Promise<CitiesResponse> => {
  const { data } = await apiClient.get<CitiesResponse>("/admin/cities");
  return data;
};

export const getAreasByCity = async (cityId: string): Promise<AreasResponse> => {
  const { data } = await apiClient.get<AreasResponse>(`/admin/cities/${cityId}/areas`);
  return data;
};

export const createCity = async (payload: { name: string; status: string }): Promise<CityResponse> => {
  const { data } = await apiClient.post<CityResponse>("/admin/cities", payload);
  return data;
};

export const updateCity = async (id: string, payload: { name?: string; status?: string }): Promise<CityResponse> => {
  const { data } = await apiClient.patch<CityResponse>(`/admin/cities/${id}`, payload);
  return data;
};

export const createArea = async (cityId: string, payload: { name: string; isActive: boolean }): Promise<AreaResponse> => {
  const { data } = await apiClient.post<AreaResponse>(`/admin/cities/${cityId}/areas`, payload);
  return data;
};

export const updateArea = async (id: string, payload: { name?: string; isActive?: boolean }): Promise<AreaResponse> => {
  const { data } = await apiClient.patch<AreaResponse>(`/admin/areas/${id}`, payload);
  return data;
};
