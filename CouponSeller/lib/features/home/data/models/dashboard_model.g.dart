// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardResponseModelImpl _$$DashboardResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardResponseModelImpl(
  success: json['success'] as bool,
  data: DashboardDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DashboardResponseModelImplToJson(
  _$DashboardResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$DashboardDataModelImpl _$$DashboardDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardDataModelImpl(
  totalRedemptions: (json['totalRedemptions'] as num).toInt(),
  status: json['status'] as String,
  commissionPct: (json['commissionPct'] as num).toDouble(),
  todaysRedemptions: (json['todaysRedemptions'] as num).toInt(),
  thisWeekRedemptions: (json['thisWeekRedemptions'] as num).toInt(),
  commissionOwed: (json['commissionOwed'] as num).toDouble(),
  coinReceivable: (json['coinReceivable'] as num).toDouble(),
  recentRedemptions: (json['recentRedemptions'] as List<dynamic>)
      .map((e) => RecentRedemptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  businessName: json['businessName'] as String?,
  city: json['city'] as String?,
);

Map<String, dynamic> _$$DashboardDataModelImplToJson(
  _$DashboardDataModelImpl instance,
) => <String, dynamic>{
  'totalRedemptions': instance.totalRedemptions,
  'status': instance.status,
  'commissionPct': instance.commissionPct,
  'todaysRedemptions': instance.todaysRedemptions,
  'thisWeekRedemptions': instance.thisWeekRedemptions,
  'commissionOwed': instance.commissionOwed,
  'coinReceivable': instance.coinReceivable,
  'recentRedemptions': instance.recentRedemptions,
  'businessName': instance.businessName,
  'city': instance.city,
};

_$RecentRedemptionModelImpl _$$RecentRedemptionModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecentRedemptionModelImpl(
  id: json['id'] as String,
  couponName: json['couponName'] as String,
  amount: (json['amount'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$RecentRedemptionModelImplToJson(
  _$RecentRedemptionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'couponName': instance.couponName,
  'amount': instance.amount,
  'createdAt': instance.createdAt.toIso8601String(),
};
