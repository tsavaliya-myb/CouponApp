// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsModelImpl _$$UserSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSettingsModelImpl(
      subscriptionPrice: (json['subscriptionPrice'] as num?)?.toInt() ?? 0,
      bookValidityDays: (json['bookValidityDays'] as num?)?.toInt() ?? 0,
      maxCoinsPerTransaction:
          (json['maxCoinsPerTransaction'] as num?)?.toInt() ?? 0,
      totalActiveCoupons: (json['totalActiveCoupons'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserSettingsModelImplToJson(
        _$UserSettingsModelImpl instance) =>
    <String, dynamic>{
      'subscriptionPrice': instance.subscriptionPrice,
      'bookValidityDays': instance.bookValidityDays,
      'maxCoinsPerTransaction': instance.maxCoinsPerTransaction,
      'totalActiveCoupons': instance.totalActiveCoupons,
    };
