import 'package:equatable/equatable.dart';

class SettlementEntity extends Equatable {
  final List<SettlementItemEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const SettlementEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [items, total, page, limit, totalPages];
}

class SettlementItemEntity extends Equatable {
  final String id;
  final String sellerId;
  final DateTime weekStart;
  final DateTime weekEnd;
  final double commissionTotal;
  final String commissionStatus;
  final DateTime? commissionPaidAt;
  final double coinCompensationTotal;
  final String coinCompStatus;
  final DateTime? coinCompPaidAt;

  const SettlementItemEntity({
    required this.id,
    required this.sellerId,
    required this.weekStart,
    required this.weekEnd,
    required this.commissionTotal,
    required this.commissionStatus,
    this.commissionPaidAt,
    required this.coinCompensationTotal,
    required this.coinCompStatus,
    this.coinCompPaidAt,
  });

  @override
  List<Object?> get props => [
        id,
        sellerId,
        weekStart,
        weekEnd,
        commissionTotal,
        commissionStatus,
        commissionPaidAt,
        coinCompensationTotal,
        coinCompStatus,
        coinCompPaidAt,
      ];
}
