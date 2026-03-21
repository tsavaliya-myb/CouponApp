import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getUsers, getUserById, blockUser, unblockUser } from "@/services/users.service";
import { GetUsersParams } from "@/types/api/users";

export const useUsers = (params?: GetUsersParams) => {
  return useQuery({
    queryKey: ["users", params],
    queryFn: () => getUsers(params),
  });
};

export const useUserDetail = (userId: string | null) => {
  return useQuery({
    queryKey: ["user", userId],
    queryFn: () => getUserById(userId as string),
    enabled: !!userId,
  });
};

export const useBlockUser = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: blockUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      queryClient.invalidateQueries({ queryKey: ["user"] });
    },
  });
};

export const useUnblockUser = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: unblockUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      queryClient.invalidateQueries({ queryKey: ["user"] });
    },
  });
};


