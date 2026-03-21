import { apiClient } from "@/lib/apiClient";
import { UsersResponse, GetUsersParams, UserDetailResponse, UserBlockResponse } from "@/types/api/users";

export const getUsers = async (params?: GetUsersParams): Promise<UsersResponse> => {
  const { data } = await apiClient.get<UsersResponse>("/admin/users", {
    params,
  });
  return data;
};

export const getUserById = async (userId: string): Promise<UserDetailResponse> => {
  const { data } = await apiClient.get<UserDetailResponse>(`/admin/users/${userId}`);
  return data;
};

export const blockUser = async (userId: string): Promise<UserBlockResponse> => {
  const { data } = await apiClient.patch<UserBlockResponse>(`/admin/users/${userId}/block`);
  return data;
};

export const unblockUser = async (userId: string): Promise<UserBlockResponse> => {
  const { data } = await apiClient.patch<UserBlockResponse>(`/admin/users/${userId}/block`);
  return data;
};


