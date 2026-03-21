import { useMutation } from "@tanstack/react-query";
import { loginAdmin } from "@/services/auth.service";

export const useLogin = () => {
  return useMutation({
    mutationFn: (credentials: Parameters<typeof loginAdmin>) => 
      loginAdmin(credentials[0], credentials[1]),
  });
};

export const useLogout = () => {
  return useMutation({
    mutationFn: () => {
      // Intentionally dynamically required so we avoid circular imports with apiClient inside services
      return import("@/services/auth.service").then(m => m.logoutAdmin());
    },
  });
};
