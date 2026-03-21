import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getCoupons, createCoupon, updateCoupon, toggleCouponStatus } from "@/services/coupons.service";
import { GetCouponsParams, CreateCouponParams, UpdateCouponParams } from "@/types/api/coupons";

export const useCoupons = (params?: GetCouponsParams) => {
  return useQuery({
    queryKey: ["coupons", params],
    queryFn: () => getCoupons(params),
  });
};

export const useCreateCoupon = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateCouponParams) => createCoupon(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["coupons"] });
    },
  });
};

export const useUpdateCoupon = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateCouponParams }) => updateCoupon(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["coupons"] });
    },
  });
};

export const useToggleCouponStatus = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => toggleCouponStatus(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["coupons"] });
    },
  });
};
