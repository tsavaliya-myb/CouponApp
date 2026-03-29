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
