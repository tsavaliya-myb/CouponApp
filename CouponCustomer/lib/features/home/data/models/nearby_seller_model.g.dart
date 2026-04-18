// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerMediaModelImpl _$$SellerMediaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SellerMediaModelImpl(
      logoUrl: json['logoUrl'] as String?,
      photoUrl1: json['photoUrl1'] as String?,
      photoUrl2: json['photoUrl2'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );

Map<String, dynamic> _$$SellerMediaModelImplToJson(
        _$SellerMediaModelImpl instance) =>
    <String, dynamic>{
      'logoUrl': instance.logoUrl,
      'photoUrl1': instance.photoUrl1,
      'photoUrl2': instance.photoUrl2,
      'videoUrl': instance.videoUrl,
    };

_$NearbySellerModelImpl _$$NearbySellerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbySellerModelImpl(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      category: json['category'] is Map
          ? (json['category'] as Map<String, dynamic>)['slug'] as String? ?? ''
          : json['category'] as String? ?? '',
      area: json['area'] as String? ?? '',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      logoUrl: json['logoUrl'] as String?,
      media: json['media'] == null
          ? null
          : SellerMediaModel.fromJson(json['media'] as Map<String, dynamic>),
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
      'media': instance.media,
    };
