// lib/features/home/domain/entities/nearby_seller_entity.dart
import 'package:equatable/equatable.dart';

class NearbySellerEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final double distanceKm;
  final double rating;
  final int totalRatings;
  final String? imageUrl;
  final String bestCouponLabel; // e.g. "20% OFF" or "BUY 1 GET 1"

  const NearbySellerEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.distanceKm,
    required this.rating,
    required this.totalRatings,
    this.imageUrl,
    required this.bestCouponLabel,
  });

  @override
  List<Object?> get props => [id];
}
