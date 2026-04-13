// lib/features/home/domain/entities/seller_media_entity.dart
import 'package:equatable/equatable.dart';

/// A single slide item in the seller media carousel.
class SellerMediaItem {
  final String url;
  final bool isVideo;
  const SellerMediaItem({required this.url, required this.isVideo});
}

class SellerMediaEntity extends Equatable {
  final String? logoUrl;
  final String? photoUrl1;
  final String? photoUrl2;
  final String? videoUrl;

  const SellerMediaEntity({
    this.logoUrl,
    this.photoUrl1,
    this.photoUrl2,
    this.videoUrl,
  });

  /// Returns all non-null media items in display order:
  /// photo1 → photo2 → video
  List<SellerMediaItem> get items {
    final result = <SellerMediaItem>[];
    if (photoUrl1 != null && photoUrl1!.isNotEmpty) {
      result.add(SellerMediaItem(url: photoUrl1!, isVideo: false));
    }
    if (photoUrl2 != null && photoUrl2!.isNotEmpty) {
      result.add(SellerMediaItem(url: photoUrl2!, isVideo: false));
    }
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      result.add(SellerMediaItem(url: videoUrl!, isVideo: true));
    }
    return result;
  }

  bool get hasMedia => items.isNotEmpty;

  @override
  List<Object?> get props => [logoUrl, photoUrl1, photoUrl2, videoUrl];
}
