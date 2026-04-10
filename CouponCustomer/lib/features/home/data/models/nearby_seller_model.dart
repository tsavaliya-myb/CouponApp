// lib/features/home/data/models/nearby_seller_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nearby_seller_entity.dart';

part 'nearby_seller_model.freezed.dart';
part 'nearby_seller_model.g.dart';

@freezed
class NearbySellerModel with _$NearbySellerModel {
  const factory NearbySellerModel({
    required String id,
    required String businessName,
    required String category,
    required String area,
    required double lat,
    required double lng,
    double? distanceKm,
    String? logoUrl,
  }) = _NearbySellerModel;

  factory NearbySellerModel.fromJson(Map<String, dynamic> json) =>
      _$NearbySellerModelFromJson(json);
}

extension NearbySellerModelX on NearbySellerModel {
  NearbySellerEntity toEntity() => NearbySellerEntity(
        id: id,
        name: businessName,
        category: category,
        area: area,
        distanceKm: distanceKm,
        lat: lat,
        lng: lng,
        logoUrl: logoUrl,
      );
}
