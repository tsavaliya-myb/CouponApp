// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SendOtpResponseModelImpl _$$SendOtpResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SendOtpResponseModelImpl(
      success: json['success'] as bool,
      data: SendOtpDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SendOtpResponseModelImplToJson(
        _$SendOtpResponseModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

_$SendOtpDataModelImpl _$$SendOtpDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SendOtpDataModelImpl(
      message: json['message'] as String,
    );

Map<String, dynamic> _$$SendOtpDataModelImplToJson(
        _$SendOtpDataModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

_$VerifyOtpResponseModelImpl _$$VerifyOtpResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyOtpResponseModelImpl(
      success: json['success'] as bool,
      data: VerifyOtpDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VerifyOtpResponseModelImplToJson(
        _$VerifyOtpResponseModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

_$VerifyOtpDataModelImpl _$$VerifyOtpDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyOtpDataModelImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: json['user'] == null
          ? null
          : AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      isNewUser: json['isNewUser'] as bool? ?? false,
      subscriptionStatus: json['subscriptionStatus'] as String? ?? 'NONE',
    );

Map<String, dynamic> _$$VerifyOtpDataModelImplToJson(
        _$VerifyOtpDataModelImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'isNewUser': instance.isNewUser,
      'subscriptionStatus': instance.subscriptionStatus,
    };

_$AuthUserModelImpl _$$AuthUserModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserModelImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      cityId: json['cityId'] as String?,
      areaId: json['areaId'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
    );

Map<String, dynamic> _$$AuthUserModelImplToJson(_$AuthUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'cityId': instance.cityId,
      'areaId': instance.areaId,
      'status': instance.status,
    };
