// lib/features/home/domain/entities/banner_ad_entity.dart
import 'package:equatable/equatable.dart';

class BannerAdEntity extends Equatable {
  final String id;
  final String? title;
  final String? imageUrl;
  final String? videoUrl;
  final String? actionUrl;
  final String? sellerName;

  const BannerAdEntity({
    required this.id,
    this.title,
    this.imageUrl,
    this.videoUrl,
    this.actionUrl,
    this.sellerName,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, videoUrl, actionUrl, sellerName];
}
