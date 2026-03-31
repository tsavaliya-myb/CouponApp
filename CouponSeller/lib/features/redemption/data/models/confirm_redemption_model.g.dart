// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_redemption_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfirmRedemptionRequestModelImpl
_$$ConfirmRedemptionRequestModelImplFromJson(Map<String, dynamic> json) =>
    _$ConfirmRedemptionRequestModelImpl(
      userCouponId: json['userCouponId'] as String,
      billAmount: (json['billAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      coinsUsed: (json['coinsUsed'] as num).toDouble(),
    );

Map<String, dynamic> _$$ConfirmRedemptionRequestModelImplToJson(
  _$ConfirmRedemptionRequestModelImpl instance,
) => <String, dynamic>{
  'userCouponId': instance.userCouponId,
  'billAmount': instance.billAmount,
  'discountAmount': instance.discountAmount,
  'coinsUsed': instance.coinsUsed,
};

_$ConfirmRedemptionResponseModelImpl
_$$ConfirmRedemptionResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$ConfirmRedemptionResponseModelImpl(success: json['success'] as bool);

Map<String, dynamic> _$$ConfirmRedemptionResponseModelImplToJson(
  _$ConfirmRedemptionResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success};
