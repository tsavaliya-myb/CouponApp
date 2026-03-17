// lib/features/home/domain/entities/home_coupon_entity.dart
import 'package:equatable/equatable.dart';

class HomeCouponEntity extends Equatable {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerArea;
  final String category;
  final int discountPercent;
  final int? minSpend;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final int usesRemaining;

  const HomeCouponEntity({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerArea,
    required this.category,
    required this.discountPercent,
    this.minSpend,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.usesRemaining,
  });

  bool get isUsable =>
      isActive && usesRemaining > 0 && validUntil.isAfter(DateTime.now());

  @override
  List<Object?> get props => [id];
}
