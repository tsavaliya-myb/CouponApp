// lib/features/auth/data/models/auth_response_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

// ─── Send OTP Response ────────────────────────────────────────────────────────

@freezed
class SendOtpResponseModel with _$SendOtpResponseModel {
  const factory SendOtpResponseModel({
    required bool success,
    required SendOtpDataModel data,
  }) = _SendOtpResponseModel;

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseModelFromJson(json);
}

@freezed
class SendOtpDataModel with _$SendOtpDataModel {
  const factory SendOtpDataModel({
    required String message,
  }) = _SendOtpDataModel;

  factory SendOtpDataModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpDataModelFromJson(json);
}

// ─── Verify OTP Response ──────────────────────────────────────────────────────

@freezed
class VerifyOtpResponseModel with _$VerifyOtpResponseModel {
  const factory VerifyOtpResponseModel({
    required bool success,
    required VerifyOtpDataModel data,
  }) = _VerifyOtpResponseModel;

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);
}

@freezed
class VerifyOtpDataModel with _$VerifyOtpDataModel {
  const factory VerifyOtpDataModel({
    required String accessToken,
    required String refreshToken,
    AuthUserModel? user,
    @Default(false) bool isNewUser,
  }) = _VerifyOtpDataModel;

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataModelFromJson(json);
}

// ─── Auth User (embedded in verify response) ─────────────────────────────────

@freezed
class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    required String id,
    required String phone,
    String? name,
    String? email,
    String? cityId,
    String? areaId,
    @Default('ACTIVE') String status,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}
