import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_user_model.freezed.dart';
part 'verify_user_model.g.dart';

@freezed
class VerifyUserResponseModel with _$VerifyUserResponseModel {
  const factory VerifyUserResponseModel({
    required bool success,
    required VerifyUserDataModel data,
  }) = _VerifyUserResponseModel;

  factory VerifyUserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyUserResponseModelFromJson(json);
}

@freezed
class VerifyUserDataModel with _$VerifyUserDataModel {
  const factory VerifyUserDataModel({
    required RedemptionUserModel user,
    required List<EligibleCouponModel> eligibleCoupons,
  }) = _VerifyUserDataModel;

  factory VerifyUserDataModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyUserDataModelFromJson(json);
}

@freezed
class RedemptionUserModel with _$RedemptionUserModel {
  const factory RedemptionUserModel({
    required String id,
    required String name,
    required String phone,
    required bool hasActiveSubscription,
    required double availableCoins,
  }) = _RedemptionUserModel;

  factory RedemptionUserModel.fromJson(Map<String, dynamic> json) =>
      _$RedemptionUserModelFromJson(json);
}

@freezed
class EligibleCouponModel with _$EligibleCouponModel {
  const factory EligibleCouponModel({
    required String id,
    required String couponBookId,
    required String couponId,
    required int usesRemaining,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required RedemptionCouponModel coupon,
  }) = _EligibleCouponModel;

  factory EligibleCouponModel.fromJson(Map<String, dynamic> json) =>
      _$EligibleCouponModelFromJson(json);
}

@freezed
class RedemptionCouponModel with _$RedemptionCouponModel {
  const factory RedemptionCouponModel({
    required String id,
    required String sellerId,
    required double discountPct,
    required double adminCommissionPct,
    required double minSpend,
    required int maxUsesPerBook,
    required String type,
    required String status,
    required bool isBaseCoupon,
  }) = _RedemptionCouponModel;

  factory RedemptionCouponModel.fromJson(Map<String, dynamic> json) =>
      _$RedemptionCouponModelFromJson(json);
}
