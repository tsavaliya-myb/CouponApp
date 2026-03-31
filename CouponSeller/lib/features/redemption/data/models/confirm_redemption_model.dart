import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_redemption_model.freezed.dart';
part 'confirm_redemption_model.g.dart';

@freezed
class ConfirmRedemptionRequestModel with _$ConfirmRedemptionRequestModel {
  const factory ConfirmRedemptionRequestModel({
    required String userCouponId,
    required double billAmount,
    required double discountAmount,
    required double coinsUsed,
  }) = _ConfirmRedemptionRequestModel;

  factory ConfirmRedemptionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmRedemptionRequestModelFromJson(json);
}

@freezed
class ConfirmRedemptionResponseModel with _$ConfirmRedemptionResponseModel {
  const factory ConfirmRedemptionResponseModel({
    required bool success,
    // Add other fields if needed, but for now we basically just need success
  }) = _ConfirmRedemptionResponseModel;

  factory ConfirmRedemptionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmRedemptionResponseModelFromJson(json);
}
