// lib/features/home/data/models/nearby_seller_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nearby_seller_entity.dart';

part 'nearby_seller_model.freezed.dart';
part 'nearby_seller_model.g.dart';

@freezed
class NearbySellerModel with _$NearbySellerModel {
  const factory NearbySellerModel({
    required String id,
    required String name,
    required String category,
    required String area,
    required double distanceKm,
    required double rating,
    required int totalRatings,
    String? imageUrl,
    required String bestCouponLabel,
  }) = _NearbySellerModel;

  factory NearbySellerModel.fromJson(Map<String, dynamic> json) =>
      _$NearbySellerModelFromJson(json);
}

extension NearbySellerModelX on NearbySellerModel {
  NearbySellerEntity toEntity() => NearbySellerEntity(
        id: id,
        name: name,
        category: category,
        area: area,
        distanceKm: distanceKm,
        rating: rating,
        totalRatings: totalRatings,
        imageUrl: imageUrl,
        bestCouponLabel: bestCouponLabel,
      );
}
