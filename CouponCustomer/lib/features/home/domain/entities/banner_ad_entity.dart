// lib/features/home/domain/entities/banner_ad_entity.dart
import 'package:equatable/equatable.dart';

class BannerAdEntity extends Equatable {
  final String id;
  final String? imageUrl;
  final String? videoUrl;
  final String? actionUrl;
  final String? sellerName;

  const BannerAdEntity({
    required this.id,
    this.imageUrl,
    this.videoUrl,
    this.actionUrl,
    this.sellerName,
  });

  @override
  List<Object?> get props => [id, imageUrl, videoUrl, actionUrl, sellerName];
}
