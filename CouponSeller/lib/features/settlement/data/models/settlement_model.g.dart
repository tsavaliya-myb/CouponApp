// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettlementResponseModelImpl _$$SettlementResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementResponseModelImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => SettlementItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: SettlementMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SettlementResponseModelImplToJson(
  _$SettlementResponseModelImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
};

_$SettlementItemModelImpl _$$SettlementItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementItemModelImpl(
  id: json['id'] as String,
  sellerId: json['sellerId'] as String,
  weekStart: DateTime.parse(json['weekStart'] as String),
  weekEnd: DateTime.parse(json['weekEnd'] as String),
  commissionTotal: (json['commissionTotal'] as num).toDouble(),
  commissionStatus: json['commissionStatus'] as String,
  commissionPaidAt: json['commissionPaidAt'] == null
      ? null
      : DateTime.parse(json['commissionPaidAt'] as String),
  coinCompensationTotal: (json['coinCompensationTotal'] as num).toDouble(),
  coinCompStatus: json['coinCompStatus'] as String,
  coinCompPaidAt: json['coinCompPaidAt'] == null
      ? null
      : DateTime.parse(json['coinCompPaidAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$SettlementItemModelImplToJson(
  _$SettlementItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sellerId': instance.sellerId,
  'weekStart': instance.weekStart.toIso8601String(),
  'weekEnd': instance.weekEnd.toIso8601String(),
  'commissionTotal': instance.commissionTotal,
  'commissionStatus': instance.commissionStatus,
  'commissionPaidAt': instance.commissionPaidAt?.toIso8601String(),
  'coinCompensationTotal': instance.coinCompensationTotal,
  'coinCompStatus': instance.coinCompStatus,
  'coinCompPaidAt': instance.coinCompPaidAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$SettlementMetaModelImpl _$$SettlementMetaModelImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementMetaModelImpl(
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$$SettlementMetaModelImplToJson(
  _$SettlementMetaModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};
