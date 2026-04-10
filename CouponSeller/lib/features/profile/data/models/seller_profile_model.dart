import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/seller_profile_entity.dart';

part 'seller_profile_model.freezed.dart';
part 'seller_profile_model.g.dart';

@freezed
class SellerProfileResponseModel with _$SellerProfileResponseModel {
  const factory SellerProfileResponseModel({
    required bool success,
    required SellerProfileModel data,
  }) = _SellerProfileResponseModel;

  factory SellerProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SellerProfileResponseModelFromJson(json);
}

@freezed
class SellerProfileModel with _$SellerProfileModel {
  const factory SellerProfileModel({
    required String id,
    required String businessName,
    required String category,
    required String cityId,
    required String areaId,
    String? address,
    required String phone,
    String? email,
    String? upiId,
    double? latitude,
    double? longitude,
    String? operatingHours,
    required double commissionPct,
    required String status,
    String? onesignalPlayerId,
    required String createdAt,
    required String updatedAt,
    required SellerCityModel city,
    required SellerAreaModel area,
    SellerMediaModel? media,
  }) = _SellerProfileModel;

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$SellerProfileModelFromJson(json);
}

@freezed
class SellerCityModel with _$SellerCityModel {
  const factory SellerCityModel({
    required String id,
    required String name,
  }) = _SellerCityModel;

  factory SellerCityModel.fromJson(Map<String, dynamic> json) =>
      _$SellerCityModelFromJson(json);
}

@freezed
class SellerAreaModel with _$SellerAreaModel {
  const factory SellerAreaModel({
    required String id,
    required String name,
  }) = _SellerAreaModel;

  factory SellerAreaModel.fromJson(Map<String, dynamic> json) =>
      _$SellerAreaModelFromJson(json);
}

@freezed
class SellerMediaModel with _$SellerMediaModel {
  const factory SellerMediaModel({
    required String id,
    required String sellerId,
    String? logoUrl,
    String? photoUrl1,
    String? photoUrl2,
    String? videoUrl,
  }) = _SellerMediaModel;

  factory SellerMediaModel.fromJson(Map<String, dynamic> json) =>
      _$SellerMediaModelFromJson(json);
}

extension SellerProfileModelX on SellerProfileModel {
  SellerProfileEntity toEntity() => SellerProfileEntity(
        id: id,
        businessName: businessName,
        category: category,
        cityId: cityId,
        areaId: areaId,
        address: address,
        phone: phone,
        email: email,
        upiId: upiId,
        latitude: latitude,
        longitude: longitude,
        commissionPct: commissionPct,
        status: status,
        createdAt: createdAt,
        cityName: city.name,
        areaName: area.name,
        logoUrl: media?.logoUrl,
        photoUrl1: media?.photoUrl1,
        photoUrl2: media?.photoUrl2,
        videoUrl: media?.videoUrl,
      );
}
