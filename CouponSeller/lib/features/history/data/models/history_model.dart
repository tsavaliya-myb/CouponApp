import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_model.freezed.dart';
part 'history_model.g.dart';

@freezed
class HistoryResponseModel with _$HistoryResponseModel {
  const factory HistoryResponseModel({
    required bool success,
    required List<RedemptionModel> data,
    required MetaDataModel meta,
  }) = _HistoryResponseModel;

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseModelFromJson(json);
}

@freezed
class RedemptionModel with _$RedemptionModel {
  const factory RedemptionModel({
    required String id,
    required String userCouponId,
    required String sellerId,
    required String userId,
    required double billAmount,
    required double discountAmount,
    required double coinsUsed,
    required double finalAmount,
    required DateTime redeemedAt,
    UserModel? user,
    UserCouponModel? userCoupon,
    SettlementLineModel? settlementLine,
  }) = _RedemptionModel;

  factory RedemptionModel.fromJson(Map<String, dynamic> json) =>
      _$RedemptionModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? name,
    String? phone,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class UserCouponModel with _$UserCouponModel {
  const factory UserCouponModel({
    required String id,
    required String couponBookId,
    required String couponId,
    required int usesRemaining,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    CouponModel? coupon,
  }) = _UserCouponModel;

  factory UserCouponModel.fromJson(Map<String, dynamic> json) =>
      _$UserCouponModelFromJson(json);
}

@freezed
class CouponModel with _$CouponModel {
  const factory CouponModel({
    required String type,
    required double discountPct,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);
}

@freezed
class SettlementLineModel with _$SettlementLineModel {
  const factory SettlementLineModel({
    required double commissionAmt,
    required double coinCompAmt,
  }) = _SettlementLineModel;

  factory SettlementLineModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementLineModelFromJson(json);
}

@freezed
class MetaDataModel with _$MetaDataModel {
  const factory MetaDataModel({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _MetaDataModel;

  factory MetaDataModel.fromJson(Map<String, dynamic> json) =>
      _$MetaDataModelFromJson(json);
}
