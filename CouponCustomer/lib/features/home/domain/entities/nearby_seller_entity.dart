// lib/features/home/domain/entities/nearby_seller_entity.dart
import 'package:equatable/equatable.dart';

class NearbySellerEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final double lat;
  final double lng;
  final double? distanceKm;
  final String? logoUrl;

  const NearbySellerEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.lat,
    required this.lng,
    this.distanceKm,
    this.logoUrl,
  });

  NearbySellerEntity copyWith({
    String? id,
    String? name,
    String? category,
    String? area,
    double? lat,
    double? lng,
    double? distanceKm,
    String? logoUrl,
  }) {
    return NearbySellerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      area: area ?? this.area,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distanceKm: distanceKm ?? this.distanceKm,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, category, area, lat, lng, distanceKm, logoUrl];
}
