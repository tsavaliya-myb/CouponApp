import { apiClient } from "@/lib/apiClient";
import { AuthResponse } from "@/types/api/auth";

export const loginAdmin = async (email: string, password: string): Promise<AuthResponse> => {
  const { data } = await apiClient.post<AuthResponse>("/auth/admin/login", {
    email,
    password,
  });
  return data;
};

export const logoutAdmin = async (): Promise<any> => {
  const refreshToken = localStorage.getItem("refreshToken");
  const { data } = await apiClient.post("/auth/logout", {
    refreshToken,
  });
  return data;
};
