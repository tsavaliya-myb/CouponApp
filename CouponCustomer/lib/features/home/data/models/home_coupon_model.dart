// lib/features/home/data/models/home_coupon_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_coupon_entity.dart';

part 'home_coupon_model.freezed.dart';
part 'home_coupon_model.g.dart';

@freezed
class HomeCouponModel with _$HomeCouponModel {
  const factory HomeCouponModel({
    required String id,
    required String sellerId,
    required String sellerName,
    required String sellerArea,
    required String category,
    required int discountPercent,
    int? minSpend,
    required String validFrom,
    required String validUntil,
    @Default(true) bool isActive,
    @Default(1) int usesRemaining,
  }) = _HomeCouponModel;

  factory HomeCouponModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCouponModelFromJson(json);
}

extension HomeCouponModelX on HomeCouponModel {
  HomeCouponEntity toEntity() => HomeCouponEntity(
        id: id,
        sellerId: sellerId,
        sellerName: sellerName,
        sellerArea: sellerArea,
        category: category,
        discountPercent: discountPercent,
        minSpend: minSpend,
        validFrom: DateTime.parse(validFrom),
        validUntil: DateTime.parse(validUntil),
        isActive: isActive,
        usesRemaining: usesRemaining,
      );
}
