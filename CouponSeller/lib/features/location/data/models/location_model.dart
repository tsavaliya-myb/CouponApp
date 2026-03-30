import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class CityResponseModel with _$CityResponseModel {
  const factory CityResponseModel({
    required bool success,
    required List<CityModel> data,
  }) = _CityResponseModel;

  factory CityResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CityResponseModelFromJson(json);
}

@freezed
class AreaResponseModel with _$AreaResponseModel {
  const factory AreaResponseModel({
    required bool success,
    required List<AreaModel> data,
  }) = _AreaResponseModel;

  factory AreaResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AreaResponseModelFromJson(json);
}

@freezed
class CityModel with _$CityModel {
  const factory CityModel({
    required String id,
    required String name,
    required String status,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
}

@freezed
class AreaModel with _$AreaModel {
  const factory AreaModel({
    required String id,
    required String name,
    required String cityId,
    required bool isActive,
  }) = _AreaModel;

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);
}
