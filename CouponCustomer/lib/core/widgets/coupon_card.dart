// lib/core/widgets/coupon_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/category_utils.dart';
import '../../features/home/domain/entities/home_coupon_entity.dart';

class CouponCard extends StatelessWidget {
  final HomeCouponEntity coupon;
  final bool showUsesLeft;
  final bool isBlurred;
  final VoidCallback? onTap;

  const CouponCard({
    super.key,
    required this.coupon,
    this.showUsesLeft = false,
    this.isBlurred = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    // Category-based branding colors
    final (brandBg, brandOnBg) = CategoryUtils.getCategoryColors(coupon.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Left side (Brand)
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: brandBg,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(24)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.dsSurfaceContainerLowest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CategoryUtils.getIcon(coupon.category),
                          color: brandOnBg,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          coupon.sellerName.toUpperCase(),
                          style: AppTextStyles.dsLabelMd.copyWith(
                              color: brandOnBg,
                              fontSize: 9,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right side (Details)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${coupon.discountPercent}% OFF',
                            style: AppTextStyles.dsDisplayLg.copyWith(
                                fontSize: 24, color: AppColors.dsSecondaryMint),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.dsSecondaryMint.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              coupon.couponType,
                              style: AppTextStyles.dsLabelMd.copyWith(
                                color: AppColors.dsSecondaryMint,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Compact Title/Location/MinSpend Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 10,
                                        color: AppColors.dsOnSurface
                                            .withOpacity(0.5)),
                                    const SizedBox(width: 2),
                                    Text(
                                      coupon.sellerArea,
                                      style: AppTextStyles.dsLabelMd.copyWith(
                                          color: AppColors.dsOnSurface
                                              .withOpacity(0.5),
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                if (coupon.minSpend != null)
                                  Text(
                                    'MIN SPEND: ₹${coupon.minSpend}',
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                      color: AppColors.dsOnSurface,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Dashed divider
                      Row(
                        children: List.generate(
                          24,
                          (_) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 1,
                              color: AppColors.dsSurfaceContainerLow,
                            ),
                          ),
                        ),
                      ),

                      // Footer Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('VALID TILL',
                                  style: AppTextStyles.dsLabelMd.copyWith(
                                      fontSize: 8,
                                      color: AppColors.dsOnSurface
                                          .withOpacity(0.4))),
                              Text(
                                  dateFormat
                                      .format(coupon.validUntil)
                                      .toUpperCase(),
                                  style: AppTextStyles.dsLabelMd.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.dsTertiaryPink)),
                            ],
                          ),
                          if (showUsesLeft)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('USES LEFT',
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                        fontSize: 8,
                                        color: AppColors.dsOnSurface
                                            .withOpacity(0.4))),
                                Text(
                                    '${coupon.usesRemaining} / ${coupon.maxUsesPerBook}',
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.dsOnSurface)),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Left Punch Out
          Positioned(
            left: -12,
            top: 48,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.dsSurface,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Right Punch Out
          Positioned(
            right: -12,
            top: 48,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.dsSurface,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ── Blur Overlay (non-subscriber) ─────────────────────────────
          if (isBlurred)
            Positioned(
              left: 100,   // starts after the brand left panel
              top: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.dsSurfaceContainerLowest.withOpacity(0.7),
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          color: AppColors.dsPrimary,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Subscribe to\nsee reward',
                          style: AppTextStyles.dsLabelMd.copyWith(
                            color: AppColors.dsPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),  // Stack
      ),  // Container
    );  // GestureDetector
  }
}
