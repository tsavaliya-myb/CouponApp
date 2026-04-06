// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      cityId: json['cityId'] as String?,
      areaId: json['areaId'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      subscriptionStatus: json['subscriptionStatus'] as String? ?? 'NONE',
      onesignalPlayerId: json['onesignalPlayerId'] as String?,
      coinBalance: (json['coinBalance'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      city: json['city'] == null
          ? null
          : CityModel.fromJson(json['city'] as Map<String, dynamic>),
      area: json['area'] == null
          ? null
          : AreaModel.fromJson(json['area'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'cityId': instance.cityId,
      'areaId': instance.areaId,
      'status': instance.status,
      'subscriptionStatus': instance.subscriptionStatus,
      'onesignalPlayerId': instance.onesignalPlayerId,
      'coinBalance': instance.coinBalance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'city': instance.city,
      'area': instance.area,
    };

_$CityModelImpl _$$CityModelImplFromJson(Map<String, dynamic> json) =>
    _$CityModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'ACTIVE',
    );

Map<String, dynamic> _$$CityModelImplToJson(_$CityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
    };
