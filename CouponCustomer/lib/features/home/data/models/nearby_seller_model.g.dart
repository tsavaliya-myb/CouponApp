// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbySellerModelImpl _$$NearbySellerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbySellerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      area: json['area'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalRatings: (json['totalRatings'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      bestCouponLabel: json['bestCouponLabel'] as String,
    );

Map<String, dynamic> _$$NearbySellerModelImplToJson(
        _$NearbySellerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'area': instance.area,
      'distanceKm': instance.distanceKm,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'imageUrl': instance.imageUrl,
      'bestCouponLabel': instance.bestCouponLabel,
    };
