// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerAreaModelImpl _$$SellerAreaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SellerAreaModelImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$SellerAreaModelImplToJson(
        _$SellerAreaModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$CouponSellerModelImpl _$$CouponSellerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CouponSellerModelImpl(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      category: json['category'] is Map
          ? (json['category'] as Map<String, dynamic>)['slug'] as String? ?? ''
          : json['category'] as String? ?? '',
      area: SellerAreaModel.fromJson(json['area'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CouponSellerModelImplToJson(
        _$CouponSellerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'category': instance.category,
      'area': instance.area,
    };

_$CouponDetailModelImpl _$$CouponDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CouponDetailModelImpl(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      discountPct: (json['discountPct'] as num).toInt(),
      adminCommissionPct: (json['adminCommissionPct'] as num).toInt(),
      minSpend: (json['minSpend'] as num?)?.toInt(),
      maxUsesPerBook: (json['maxUsesPerBook'] as num).toInt(),
      type: json['type'] as String,
      status: json['status'] as String,
      isBaseCoupon: json['isBaseCoupon'] as bool,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      seller:
          CouponSellerModel.fromJson(json['seller'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CouponDetailModelImplToJson(
        _$CouponDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerId': instance.sellerId,
      'discountPct': instance.discountPct,
      'adminCommissionPct': instance.adminCommissionPct,
      'minSpend': instance.minSpend,
      'maxUsesPerBook': instance.maxUsesPerBook,
      'type': instance.type,
      'status': instance.status,
      'isBaseCoupon': instance.isBaseCoupon,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'seller': instance.seller,
    };

_$CouponBookModelImpl _$$CouponBookModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CouponBookModelImpl(
      validUntil: json['validUntil'] as String,
    );

Map<String, dynamic> _$$CouponBookModelImplToJson(
        _$CouponBookModelImpl instance) =>
    <String, dynamic>{
      'validUntil': instance.validUntil,
    };

_$HomeCouponModelImpl _$$HomeCouponModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeCouponModelImpl(
      id: json['id'] as String,
      couponBookId: json['couponBookId'] as String,
      couponId: json['couponId'] as String,
      usesRemaining: (json['usesRemaining'] as num).toInt(),
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      coupon:
          CouponDetailModel.fromJson(json['coupon'] as Map<String, dynamic>),
      couponBook:
          CouponBookModel.fromJson(json['couponBook'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomeCouponModelImplToJson(
        _$HomeCouponModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'couponBookId': instance.couponBookId,
      'couponId': instance.couponId,
      'usesRemaining': instance.usesRemaining,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'coupon': instance.coupon,
      'couponBook': instance.couponBook,
    };
