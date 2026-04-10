// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbySellerModelImpl _$$NearbySellerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbySellerModelImpl(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      category: json['category'] as String,
      area: json['area'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$$NearbySellerModelImplToJson(
        _$NearbySellerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'category': instance.category,
      'area': instance.area,
      'lat': instance.lat,
      'lng': instance.lng,
      'distanceKm': instance.distanceKm,
      'logoUrl': instance.logoUrl,
    };
