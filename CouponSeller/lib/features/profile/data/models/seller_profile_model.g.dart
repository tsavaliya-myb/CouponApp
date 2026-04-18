// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerProfileResponseModelImpl _$$SellerProfileResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$SellerProfileResponseModelImpl(
  success: json['success'] as bool,
  data: SellerProfileModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SellerProfileResponseModelImplToJson(
  _$SellerProfileResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$SellerProfileModelImpl _$$SellerProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$SellerProfileModelImpl(
  id: json['id'] as String,
  businessName: json['businessName'] as String,
  category: json['category'] is Map
      ? (json['category'] as Map<String, dynamic>)['name'] as String? ?? ''
      : json['category'] as String? ?? '',
  cityId: json['cityId'] as String,
  areaId: json['areaId'] as String,
  address: json['address'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  upiId: json['upiId'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  operatingHours: json['operatingHours'] as String?,
  commissionPct: (json['commissionPct'] as num).toDouble(),
  status: json['status'] as String,
  onesignalPlayerId: json['onesignalPlayerId'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  city: SellerCityModel.fromJson(json['city'] as Map<String, dynamic>),
  area: SellerAreaModel.fromJson(json['area'] as Map<String, dynamic>),
  media: json['media'] == null
      ? null
      : SellerMediaModel.fromJson(json['media'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SellerProfileModelImplToJson(
  _$SellerProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessName': instance.businessName,
  'category': instance.category,
  'cityId': instance.cityId,
  'areaId': instance.areaId,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'upiId': instance.upiId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'operatingHours': instance.operatingHours,
  'commissionPct': instance.commissionPct,
  'status': instance.status,
  'onesignalPlayerId': instance.onesignalPlayerId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'city': instance.city,
  'area': instance.area,
  'media': instance.media,
};

_$SellerCityModelImpl _$$SellerCityModelImplFromJson(
  Map<String, dynamic> json,
) => _$SellerCityModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$SellerCityModelImplToJson(
  _$SellerCityModelImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$SellerAreaModelImpl _$$SellerAreaModelImplFromJson(
  Map<String, dynamic> json,
) => _$SellerAreaModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$SellerAreaModelImplToJson(
  _$SellerAreaModelImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$SellerMediaModelImpl _$$SellerMediaModelImplFromJson(
  Map<String, dynamic> json,
) => _$SellerMediaModelImpl(
  id: json['id'] as String,
  sellerId: json['sellerId'] as String,
  logoUrl: json['logoUrl'] as String?,
  photoUrl1: json['photoUrl1'] as String?,
  photoUrl2: json['photoUrl2'] as String?,
  videoUrl: json['videoUrl'] as String?,
);

Map<String, dynamic> _$$SellerMediaModelImplToJson(
  _$SellerMediaModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sellerId': instance.sellerId,
  'logoUrl': instance.logoUrl,
  'photoUrl1': instance.photoUrl1,
  'photoUrl2': instance.photoUrl2,
  'videoUrl': instance.videoUrl,
};
