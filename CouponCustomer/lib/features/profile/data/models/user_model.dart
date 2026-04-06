import 'package:freezed_annotation/freezed_annotation.dart';
import 'area_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @Default('') String phone,
    String? name,
    String? email,
    String? cityId,
    String? areaId,
    @Default('ACTIVE') String status,
    @Default('NONE') String subscriptionStatus,
    String? onesignalPlayerId,
    @Default(0) int coinBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
    CityModel? city,
    AreaModel? area,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class CityModel with _$CityModel {
  const factory CityModel({
    required String id,
    required String name,
    @Default('ACTIVE') String status,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
}
