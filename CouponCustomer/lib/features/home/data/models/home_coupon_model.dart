// lib/features/home/data/models/home_coupon_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_coupon_entity.dart';

part 'home_coupon_model.freezed.dart';
part 'home_coupon_model.g.dart';

// ─── Inner seller area ────────────────────────────────────────────────────────

@freezed
class SellerAreaModel with _$SellerAreaModel {
  const factory SellerAreaModel({required String name}) = _SellerAreaModel;
  factory SellerAreaModel.fromJson(Map<String, dynamic> json) =>
      _$SellerAreaModelFromJson(json);
}

// ─── Inner seller ─────────────────────────────────────────────────────────────

@freezed
class CouponSellerModel with _$CouponSellerModel {
  const factory CouponSellerModel({
    required String id,
    required String businessName,
    required String category,
    required SellerAreaModel area,
  }) = _CouponSellerModel;

  factory CouponSellerModel.fromJson(Map<String, dynamic> json) =>
      _$CouponSellerModelFromJson(json);
}

// ─── Inner coupon detail ──────────────────────────────────────────────────────

@freezed
class CouponDetailModel with _$CouponDetailModel {
  const factory CouponDetailModel({
    required String id,
    required String sellerId,
    required int discountPct,
    required int adminCommissionPct,
    int? minSpend,
    required int maxUsesPerBook,
    required String type,
    required String status,
    required bool isBaseCoupon,
    String? description,
    required String createdAt,
    required String updatedAt,
    required CouponSellerModel seller,
  }) = _CouponDetailModel;

  factory CouponDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CouponDetailModelFromJson(json);
}

// ─── Inner coupon book ────────────────────────────────────────────────────────

@freezed
class CouponBookModel with _$CouponBookModel {
  const factory CouponBookModel({
    required String validUntil,
  }) = _CouponBookModel;

  factory CouponBookModel.fromJson(Map<String, dynamic> json) =>
      _$CouponBookModelFromJson(json);
}

// ─── Top-level user-coupon entry ──────────────────────────────────────────────

@freezed
class HomeCouponModel with _$HomeCouponModel {
  const factory HomeCouponModel({
    required String id,
    required String couponBookId,
    required String couponId,
    required int usesRemaining,
    required String status,
    required String createdAt,
    required String updatedAt,
    required CouponDetailModel coupon,
    required CouponBookModel couponBook,
  }) = _HomeCouponModel;

  factory HomeCouponModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCouponModelFromJson(json);
}

extension HomeCouponModelX on HomeCouponModel {
  HomeCouponEntity toEntity() => HomeCouponEntity(
        id: id,
        sellerId: coupon.seller.id,
        sellerName: coupon.seller.businessName,
        sellerArea: coupon.seller.area.name,
        category: coupon.seller.category,
        discountPercent: coupon.discountPct,
        couponType: coupon.type,
        minSpend: coupon.minSpend,
        description: coupon.description,
        validFrom: DateTime.parse(createdAt),
        validUntil: DateTime.parse(couponBook.validUntil),
        isActive: status == 'ACTIVE',
        status: status,
        usesRemaining: usesRemaining,
        maxUsesPerBook: coupon.maxUsesPerBook,
      );
}
