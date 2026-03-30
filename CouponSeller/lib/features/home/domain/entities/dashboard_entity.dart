import 'package:equatable/equatable.dart';

class RecentRedemptionEntity extends Equatable {
  final String id;
  final String couponName;
  final double amount;
  final DateTime createdAt;

  const RecentRedemptionEntity({
    required this.id,
    required this.couponName,
    required this.amount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, couponName, amount, createdAt];
}

class DashboardEntity extends Equatable {
  final int totalRedemptions;
  final String status;
  final double commissionPct;
  final int todaysRedemptions;
  final int thisWeekRedemptions;
  final double commissionOwed;
  final double coinReceivable;
  final List<RecentRedemptionEntity> recentRedemptions;
  final String? businessName;
  final String? city;

  const DashboardEntity({
    required this.totalRedemptions,
    required this.status,
    required this.commissionPct,
    required this.todaysRedemptions,
    required this.thisWeekRedemptions,
    required this.commissionOwed,
    required this.coinReceivable,
    required this.recentRedemptions,
    this.businessName,
    this.city,
  });

  @override
  List<Object?> get props => [
        totalRedemptions,
        status,
        commissionPct,
        todaysRedemptions,
        thisWeekRedemptions,
        commissionOwed,
        coinReceivable,
        recentRedemptions,
        businessName,
        city,
      ];
}
