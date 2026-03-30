import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final List<RedemptionEntity> redemptions;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const HistoryEntity({
    required this.redemptions,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [redemptions, total, page, limit, totalPages];
}

class RedemptionEntity extends Equatable {
  final String id;
  final String userCouponId;
  final String sellerId;
  final String userId;
  final double billAmount;
  final double discountAmount;
  final double coinsUsed;
  final double finalAmount;
  final DateTime redeemedAt;
  final String userName;
  final String userPhone;
  final String couponType;
  final double couponDiscountPct;
  final double commissionAmt;
  final double coinCompAmt;

  const RedemptionEntity({
    required this.id,
    required this.userCouponId,
    required this.sellerId,
    required this.userId,
    required this.billAmount,
    required this.discountAmount,
    required this.coinsUsed,
    required this.finalAmount,
    required this.redeemedAt,
    required this.userName,
    required this.userPhone,
    required this.couponType,
    required this.couponDiscountPct,
    required this.commissionAmt,
    required this.coinCompAmt,
  });

  @override
  List<Object?> get props => [
        id,
        userCouponId,
        sellerId,
        userId,
        billAmount,
        discountAmount,
        coinsUsed,
        finalAmount,
        redeemedAt,
        userName,
        userPhone,
        couponType,
        couponDiscountPct,
        commissionAmt,
        coinCompAmt,
      ];
}
