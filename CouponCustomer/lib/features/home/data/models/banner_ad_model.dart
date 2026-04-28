// lib/features/home/data/models/banner_ad_model.dart
import '../../domain/entities/banner_ad_entity.dart';

class BannerAdModel extends BannerAdEntity {
  const BannerAdModel({
    required super.id,
    super.imageUrl,
    super.videoUrl,
    super.actionUrl,
    super.sellerName,
  });

  factory BannerAdModel.fromJson(Map<String, dynamic> json) {
    final seller = json['seller'] as Map<String, dynamic>?;
    return BannerAdModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      sellerName: seller?['businessName'] as String?,
    );
  }
}
