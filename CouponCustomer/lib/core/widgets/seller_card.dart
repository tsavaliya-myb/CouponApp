// lib/core/widgets/seller_card.dart
import 'package:flutter/material.dart';
import '../../features/home/domain/entities/nearby_seller_entity.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/category_utils.dart';

class SellerCard extends StatelessWidget {
  final NearbySellerEntity seller;
  final VoidCallback? onTap;

  const SellerCard({
    super.key,
    required this.seller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.dsSurfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.dsOnSurface.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Brand/Category Imagery ---
                    _SellerBrandArea(category: seller.category),
                    
                    const SizedBox(width: 16),
                    
                    // --- Content Area ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  seller.name,
                                  style: AppTextStyles.dsTitleLg.copyWith(
                                    fontSize: 18,
                                    height: 1.1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (seller.distanceKm != null)
                                _DistanceBadge(distance: seller.distanceKm!),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                CategoryUtils.getIcon(seller.category),
                                size: 12,
                                color: AppColors.dsOnSurface.withOpacity(0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${seller.category} • ${seller.area}',
                                style: AppTextStyles.dsLabelMd.copyWith(
                                  color: AppColors.dsOnSurface.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // --- Action/Tag Area ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _StatusBadge(label: 'Top Rated'),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: AppColors.dsPrimary.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerBrandArea extends StatelessWidget {
  final String category;

  const _SellerBrandArea({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = CategoryUtils.getBaseColor(category);
    
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          CategoryUtils.getEmoji(category),
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  final double distance;

  const _DistanceBadge({required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '${distance.toStringAsFixed(1)} km',
        style: AppTextStyles.dsLabelMd.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.dsOnSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;

  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.dsSecondaryMint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.dsSecondaryMint,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.dsLabelMd.copyWith(
              color: AppColors.dsSecondaryMint,
              fontWeight: FontWeight.w800,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
