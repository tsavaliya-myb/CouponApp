import 'package:equatable/equatable.dart';

class VerifyUserEntity extends Equatable {
  final RedemptionUserEntity user;
  final List<EligibleCouponEntity> eligibleCoupons;

  const VerifyUserEntity({
    required this.user,
    required this.eligibleCoupons,
  });

  @override
  List<Object?> get props => [user, eligibleCoupons];
}

class RedemptionUserEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final bool hasActiveSubscription;
  final double availableCoins;

  const RedemptionUserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.hasActiveSubscription,
    required this.availableCoins,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        hasActiveSubscription,
        availableCoins,
      ];
}

class EligibleCouponEntity extends Equatable {
  final String id;
  final String couponBookId;
  final String couponId;
  final int usesRemaining;
  final String status;
  final RedemptionCouponEntity coupon;

  const EligibleCouponEntity({
    required this.id,
    required this.couponBookId,
    required this.couponId,
    required this.usesRemaining,
    required this.status,
    required this.coupon,
  });

  @override
  List<Object?> get props => [
        id,
        couponBookId,
        couponId,
        usesRemaining,
        status,
        coupon,
      ];
}

class RedemptionCouponEntity extends Equatable {
  final String id;
  final String sellerId;
  final double discountPct;
  final double adminCommissionPct;
  final double minSpend;
  final int maxUsesPerBook;
  final String type;
  final String status;
  final bool isBaseCoupon;

  const RedemptionCouponEntity({
    required this.id,
    required this.sellerId,
    required this.discountPct,
    required this.adminCommissionPct,
    required this.minSpend,
    required this.maxUsesPerBook,
    required this.type,
    required this.status,
    required this.isBaseCoupon,
  });

  @override
  List<Object?> get props => [
        id,
        sellerId,
        discountPct,
        adminCommissionPct,
        minSpend,
        maxUsesPerBook,
        type,
        status,
        isBaseCoupon,
      ];
}
