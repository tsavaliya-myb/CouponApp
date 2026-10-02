import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { apiClient as api } from "@/lib/apiClient";

// ─── Influencer Niches ────────────────────────────────────────────────────────

export const useInfluencerNiches = () => {
  return useQuery({
    queryKey: ["influencer-niches"],
    queryFn: async () => {
      const res = await api.get("/admin/influencer-niches");
      return res.data;
    },
  });
};

export const useCreateInfluencerNiche = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (data: any) => {
      const res = await api.post("/admin/influencer-niches", data);
      return res.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["influencer-niches"] });
    },
  });
};

export const useUpdateInfluencerNiche = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...data }: any) => {
      const res = await api.patch(`/admin/influencer-niches/${id}`, data);
      return res.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["influencer-niches"] });
    },
  });
};

export const useDeleteInfluencerNiche = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.delete(`/admin/influencer-niches/${id}`);
      return res.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["influencer-niches"] });
    },
  });
};

// ─── Influencers ──────────────────────────────────────────────────────────────

export const useInfluencers = (params: any) => {
  return useQuery({
    queryKey: ["admin-influencers", params],
    queryFn: async () => {
      const res = await api.get("/admin/influencers", { params });
      return res.data;
    },
  });
};

export const useApproveInfluencer = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.post(`/admin/influencers/${id}/approve`);
      return res.data;
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["admin-influencers"] }),
  });
};

export const useSuspendInfluencer = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.post(`/admin/influencers/${id}/suspend`);
      return res.data;
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["admin-influencers"] }),
  });
};

export const useRejectInfluencer = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await api.post(`/admin/influencers/${id}/reject`);
      return res.data;
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["admin-influencers"] }),
  });
};

export const useUpdateInfluencer = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: any }) => {
      const res = await api.patch(`/admin/influencers/${id}`, data);
      return res.data;
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["admin-influencers"] }),
  });
};
