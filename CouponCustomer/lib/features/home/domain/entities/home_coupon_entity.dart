// lib/features/home/domain/entities/home_coupon_entity.dart
import 'package:equatable/equatable.dart';

class HomeCouponEntity extends Equatable {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerArea;
  final String category;
  final int discountPercent;
  final String couponType;
  final int? minSpend;
  final String? description;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final String status;
  final int usesRemaining;
  final int maxUsesPerBook;

  const HomeCouponEntity({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerArea,
    required this.category,
    required this.discountPercent,
    required this.couponType,
    this.minSpend,
    this.description,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.status,
    required this.usesRemaining,
    required this.maxUsesPerBook,
  });

  bool get isUsable =>
      isActive && usesRemaining > 0 && validUntil.isAfter(DateTime.now());

  @override
  List<Object?> get props => [id, status];
}
