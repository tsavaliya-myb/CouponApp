// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryResponseModelImpl _$$HistoryResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$HistoryResponseModelImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => RedemptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaDataModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$HistoryResponseModelImplToJson(
  _$HistoryResponseModelImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
};

_$RedemptionModelImpl _$$RedemptionModelImplFromJson(
  Map<String, dynamic> json,
) => _$RedemptionModelImpl(
  id: json['id'] as String,
  userCouponId: json['userCouponId'] as String,
  sellerId: json['sellerId'] as String,
  userId: json['userId'] as String,
  billAmount: (json['billAmount'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num).toDouble(),
  coinsUsed: (json['coinsUsed'] as num).toDouble(),
  finalAmount: (json['finalAmount'] as num).toDouble(),
  redeemedAt: DateTime.parse(json['redeemedAt'] as String),
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  userCoupon: json['userCoupon'] == null
      ? null
      : UserCouponModel.fromJson(json['userCoupon'] as Map<String, dynamic>),
  settlementLine: json['settlementLine'] == null
      ? null
      : SettlementLineModel.fromJson(
          json['settlementLine'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$RedemptionModelImplToJson(
  _$RedemptionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userCouponId': instance.userCouponId,
  'sellerId': instance.sellerId,
  'userId': instance.userId,
  'billAmount': instance.billAmount,
  'discountAmount': instance.discountAmount,
  'coinsUsed': instance.coinsUsed,
  'finalAmount': instance.finalAmount,
  'redeemedAt': instance.redeemedAt.toIso8601String(),
  'user': instance.user,
  'userCoupon': instance.userCoupon,
  'settlementLine': instance.settlementLine,
};

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{'name': instance.name, 'phone': instance.phone};

_$UserCouponModelImpl _$$UserCouponModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserCouponModelImpl(
  id: json['id'] as String,
  couponBookId: json['couponBookId'] as String,
  couponId: json['couponId'] as String,
  usesRemaining: (json['usesRemaining'] as num).toInt(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  coupon: json['coupon'] == null
      ? null
      : CouponModel.fromJson(json['coupon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserCouponModelImplToJson(
  _$UserCouponModelImpl instance,
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

_$CouponModelImpl _$$CouponModelImplFromJson(Map<String, dynamic> json) =>
    _$CouponModelImpl(
      type: json['type'] as String,
      discountPct: (json['discountPct'] as num).toDouble(),
    );

Map<String, dynamic> _$$CouponModelImplToJson(_$CouponModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'discountPct': instance.discountPct,
    };

_$SettlementLineModelImpl _$$SettlementLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementLineModelImpl(
  commissionAmt: (json['commissionAmt'] as num).toDouble(),
  coinCompAmt: (json['coinCompAmt'] as num).toDouble(),
);

Map<String, dynamic> _$$SettlementLineModelImplToJson(
  _$SettlementLineModelImpl instance,
) => <String, dynamic>{
  'commissionAmt': instance.commissionAmt,
  'coinCompAmt': instance.coinCompAmt,
};

_$MetaDataModelImpl _$$MetaDataModelImplFromJson(Map<String, dynamic> json) =>
    _$MetaDataModelImpl(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$MetaDataModelImplToJson(_$MetaDataModelImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };
