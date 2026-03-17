// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeCouponModelImpl _$$HomeCouponModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeCouponModelImpl(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerArea: json['sellerArea'] as String,
      category: json['category'] as String,
      discountPercent: (json['discountPercent'] as num).toInt(),
      minSpend: (json['minSpend'] as num?)?.toInt(),
      validFrom: json['validFrom'] as String,
      validUntil: json['validUntil'] as String,
      isActive: json['isActive'] as bool? ?? true,
      usesRemaining: (json['usesRemaining'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$HomeCouponModelImplToJson(
        _$HomeCouponModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'sellerArea': instance.sellerArea,
      'category': instance.category,
      'discountPercent': instance.discountPercent,
      'minSpend': instance.minSpend,
      'validFrom': instance.validFrom,
      'validUntil': instance.validUntil,
      'isActive': instance.isActive,
      'usesRemaining': instance.usesRemaining,
    };
