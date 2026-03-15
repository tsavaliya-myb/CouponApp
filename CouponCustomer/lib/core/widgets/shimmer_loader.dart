// lib/core/widgets/shimmer_loader.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

/// Generic shimmer placeholder block.
class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.bgSecondary,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Coupon card shimmer (matches coupon card dimensions)
class CouponCardShimmer extends StatelessWidget {
  const CouponCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.bgSecondary,
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// Seller card shimmer
class SellerCardShimmer extends StatelessWidget {
  const SellerCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.bgSecondary,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 120, color: AppColors.bgCard),
                const SizedBox(height: 6),
                Container(height: 12, width: 80, color: AppColors.bgCard),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Builds N shimmer items using a provided builder
class ShimmerList extends StatelessWidget {
  final int count;
  final Widget Function(int index) builder;

  const ShimmerList({super.key, required this.count, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (i) => builder(i)),
    );
  }
}
