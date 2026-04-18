// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SendOtpResponseModelImpl _$$SendOtpResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$SendOtpResponseModelImpl(
  success: json['success'] as bool,
  data: SendOtpData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SendOtpResponseModelImplToJson(
  _$SendOtpResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$SendOtpDataImpl _$$SendOtpDataImplFromJson(Map<String, dynamic> json) =>
    _$SendOtpDataImpl(message: json['message'] as String);

Map<String, dynamic> _$$SendOtpDataImplToJson(_$SendOtpDataImpl instance) =>
    <String, dynamic>{'message': instance.message};

_$VerifyOtpResponseModelImpl _$$VerifyOtpResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$VerifyOtpResponseModelImpl(
  success: json['success'] as bool,
  data: VerifyOtpData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$VerifyOtpResponseModelImplToJson(
  _$VerifyOtpResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$VerifyOtpDataImpl _$$VerifyOtpDataImplFromJson(Map<String, dynamic> json) =>
    _$VerifyOtpDataImpl(
      isRegistered: json['isRegistered'] as bool,
      registrationToken: json['registrationToken'] as String?,
      status: json['status'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$$VerifyOtpDataImplToJson(_$VerifyOtpDataImpl instance) =>
    <String, dynamic>{
      'isRegistered': instance.isRegistered,
      'registrationToken': instance.registrationToken,
      'status': instance.status,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

_$RegisterSellerResponseModelImpl _$$RegisterSellerResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterSellerResponseModelImpl(
  success: json['success'] as bool,
  data: RegisterSellerData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RegisterSellerResponseModelImplToJson(
  _$RegisterSellerResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$RegisterSellerDataImpl _$$RegisterSellerDataImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterSellerDataImpl(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  seller: SellerModel.fromJson(json['seller'] as Map<String, dynamic>),
  message: json['message'] as String,
);

Map<String, dynamic> _$$RegisterSellerDataImplToJson(
  _$RegisterSellerDataImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'seller': instance.seller,
  'message': instance.message,
};

_$SellerModelImpl _$$SellerModelImplFromJson(Map<String, dynamic> json) =>
    _$SellerModelImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      businessName: json['businessName'] as String,
      category: json['category'] is Map
          ? (json['category'] as Map<String, dynamic>)['name'] as String? ?? ''
          : json['category'] as String? ?? '',
      cityId: json['cityId'] as String,
      areaId: json['areaId'] as String,
      status: json['status'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      upiId: json['upiId'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$$SellerModelImplToJson(_$SellerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'businessName': instance.businessName,
      'category': instance.category,
      'cityId': instance.cityId,
      'areaId': instance.areaId,
      'status': instance.status,
      'address': instance.address,
      'email': instance.email,
      'upiId': instance.upiId,
      'lat': instance.lat,
      'lng': instance.lng,
    };
