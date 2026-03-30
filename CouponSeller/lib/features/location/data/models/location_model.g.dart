// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CityResponseModelImpl _$$CityResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$CityResponseModelImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CityResponseModelImplToJson(
  _$CityResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$AreaResponseModelImpl _$$AreaResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AreaResponseModelImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$AreaResponseModelImplToJson(
  _$AreaResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$CityModelImpl _$$CityModelImplFromJson(Map<String, dynamic> json) =>
    _$CityModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$CityModelImplToJson(_$CityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
    };

_$AreaModelImpl _$$AreaModelImplFromJson(Map<String, dynamic> json) =>
    _$AreaModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cityId: json['cityId'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$AreaModelImplToJson(_$AreaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cityId': instance.cityId,
      'isActive': instance.isActive,
    };
