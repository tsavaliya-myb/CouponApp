// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerifyUserResponseModelImpl _$$VerifyUserResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$VerifyUserResponseModelImpl(
  success: json['success'] as bool,
  data: VerifyUserDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$VerifyUserResponseModelImplToJson(
  _$VerifyUserResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$VerifyUserDataModelImpl _$$VerifyUserDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$VerifyUserDataModelImpl(
  user: RedemptionUserModel.fromJson(json['user'] as Map<String, dynamic>),
  eligibleCoupons: (json['eligibleCoupons'] as List<dynamic>)
      .map((e) => EligibleCouponModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$VerifyUserDataModelImplToJson(
  _$VerifyUserDataModelImpl instance,
) => <String, dynamic>{
  'user': instance.user,
  'eligibleCoupons': instance.eligibleCoupons,
};

_$RedemptionUserModelImpl _$$RedemptionUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$RedemptionUserModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  hasActiveSubscription: json['hasActiveSubscription'] as bool,
  availableCoins: (json['availableCoins'] as num).toDouble(),
);

Map<String, dynamic> _$$RedemptionUserModelImplToJson(
  _$RedemptionUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'hasActiveSubscription': instance.hasActiveSubscription,
  'availableCoins': instance.availableCoins,
};

_$EligibleCouponModelImpl _$$EligibleCouponModelImplFromJson(
  Map<String, dynamic> json,
) => _$EligibleCouponModelImpl(
  id: json['id'] as String,
  couponBookId: json['couponBookId'] as String,
  couponId: json['couponId'] as String,
  usesRemaining: (json['usesRemaining'] as num).toInt(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  coupon: RedemptionCouponModel.fromJson(
    json['coupon'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$EligibleCouponModelImplToJson(
  _$EligibleCouponModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'couponBookId': instance.couponBookId,
  'couponId': instance.couponId,
  'usesRemaining': instance.usesRemaining,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'coupon': instance.coupon,
};

_$RedemptionCouponModelImpl _$$RedemptionCouponModelImplFromJson(
  Map<String, dynamic> json,
) => _$RedemptionCouponModelImpl(
  id: json['id'] as String,
  sellerId: json['sellerId'] as String,
  discountPct: (json['discountPct'] as num).toDouble(),
  adminCommissionPct: (json['adminCommissionPct'] as num).toDouble(),
  minSpend: (json['minSpend'] as num).toDouble(),
  maxUsesPerBook: (json['maxUsesPerBook'] as num).toInt(),
  type: json['type'] as String,
  status: json['status'] as String,
  isBaseCoupon: json['isBaseCoupon'] as bool,
);

Map<String, dynamic> _$$RedemptionCouponModelImplToJson(
  _$RedemptionCouponModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sellerId': instance.sellerId,
  'discountPct': instance.discountPct,
  'adminCommissionPct': instance.adminCommissionPct,
  'minSpend': instance.minSpend,
  'maxUsesPerBook': instance.maxUsesPerBook,
  'type': instance.type,
  'status': instance.status,
  'isBaseCoupon': instance.isBaseCoupon,
};
