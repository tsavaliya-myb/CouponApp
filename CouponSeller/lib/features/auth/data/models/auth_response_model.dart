import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class SendOtpResponseModel with _$SendOtpResponseModel {
  const factory SendOtpResponseModel({
    required bool success,
    required SendOtpData data,
  }) = _SendOtpResponseModel;

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseModelFromJson(json);
}

@freezed
class SendOtpData with _$SendOtpData {
  const factory SendOtpData({
    required String message,
  }) = _SendOtpData;

  factory SendOtpData.fromJson(Map<String, dynamic> json) =>
      _$SendOtpDataFromJson(json);
}

@freezed
class VerifyOtpResponseModel with _$VerifyOtpResponseModel {
  const factory VerifyOtpResponseModel({
    required bool success,
    required VerifyOtpData data,
  }) = _VerifyOtpResponseModel;

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);
}

@freezed
class VerifyOtpData with _$VerifyOtpData {
  const factory VerifyOtpData({
    required bool isRegistered,
    String? registrationToken,
    String? status,
    String? accessToken,
    String? refreshToken,
  }) = _VerifyOtpData;

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataFromJson(json);
}

@freezed
class RegisterSellerResponseModel with _$RegisterSellerResponseModel {
  const factory RegisterSellerResponseModel({
    required bool success,
    required RegisterSellerData data,
  }) = _RegisterSellerResponseModel;

  factory RegisterSellerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterSellerResponseModelFromJson(json);
}

@freezed
class RegisterSellerData with _$RegisterSellerData {
  const factory RegisterSellerData({
    required String accessToken,
    required String refreshToken,
    required SellerModel seller,
    required String message,
  }) = _RegisterSellerData;

  factory RegisterSellerData.fromJson(Map<String, dynamic> json) =>
      _$RegisterSellerDataFromJson(json);
}

@freezed
class SellerModel with _$SellerModel {
  const factory SellerModel({
    required String id,
    required String phone,
    required String businessName,
    required String category,
    required String cityId,
    required String areaId,
    required String status,
    required String address,
    required String email,
    required String upiId,
    required double lat,
    required double lng,
  }) = _SellerModel;

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);
}
