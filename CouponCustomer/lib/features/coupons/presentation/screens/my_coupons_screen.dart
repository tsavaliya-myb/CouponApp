// lib/features/coupons/presentation/screens/my_coupons_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../home/domain/entities/home_coupon_entity.dart';
import '../../../home/presentation/providers/home_provider.dart';


// ─── Category filter for the coupons screen ───────────────────────────────────

const _kCouponCategories = [
  ('ALL', 'All'),
  ('FOOD', 'Food'),
  ('CAFE', 'Cafe'),
  ('SALON', 'Salon'),
  ('THEATER', 'Theater'),
  ('SPA', 'Spa'),
  ('OTHER', 'Other'),
];

class MyCouponsScreen extends ConsumerStatefulWidget {
  const MyCouponsScreen({super.key});

  @override
  ConsumerState<MyCouponsScreen> createState() => _MyCouponsScreenState();
}

class _MyCouponsScreenState extends ConsumerState<MyCouponsScreen>
    with AutomaticKeepAliveClientMixin {
  int _statusTab = 0; // 0: Active, 1: Used, 2: Expired

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final couponsAsync = ref.watch(filteredCouponsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── App Bar ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.dsSurfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 20, color: AppColors.dsOnSurface),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('My Coupons',
                      style: AppTextStyles.dsTitleLg.copyWith(fontSize: 22)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Status Tabs (Active / Used / Expired) ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.dsSurfaceContainerLow,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    _buildStatusTab(0, 'Active'),
                    _buildStatusTab(1, 'Used'),
                    _buildStatusTab(2, 'Expired'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Category Chips ─────────────────────────────────────────────
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _kCouponCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final (key, label) = _kCouponCategories[i];
                  final isSelected = selectedCategory == key;
                  return GestureDetector(
                    onTap: () => ref
                        .read(selectedCategoryProvider.notifier)
                        .state = key,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.dsPrimary
                            : AppColors.dsSurfaceContainerLow,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          label.toUpperCase(),
                          style: AppTextStyles.dsLabelMd.copyWith(
                            fontSize: 10,
                            letterSpacing: 0.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? AppColors.dsSurfaceContainerLowest
                                : AppColors.dsOnSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ── Coupons List ───────────────────────────────────────────────
            Expanded(
              child: couponsAsync.when(
                loading: () => _buildShimmer(),
                error: (e, _) => Center(
                  child: Text('Failed to load coupons',
                      style: AppTextStyles.dsBodyMd
                          .copyWith(color: AppColors.dsTertiaryPink)),
                ),
                data: (all) {
                  final coupons = _filterByStatus(all);
                  if (coupons.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.confirmation_number_outlined,
                              size: 56,
                              color:
                                  AppColors.dsOnSurface.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          Text('No coupons here',
                              style: AppTextStyles.dsTitleLg.copyWith(
                                  color:
                                      AppColors.dsOnSurface.withOpacity(0.4))),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    itemCount: coupons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) {
                      return _VerticalCouponCard(coupon: coupons[i])
                          .animate()
                          .fadeIn(
                              duration: 300.ms,
                              delay: Duration(milliseconds: 40 * i))
                          .slideY(begin: 0.04);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<HomeCouponEntity> _filterByStatus(List<HomeCouponEntity> all) {
    final now = DateTime.now();
    return switch (_statusTab) {
      0 => all.where((c) => c.isActive && c.validUntil.isAfter(now)).toList(),
      1 => all.where((c) => c.usesRemaining == 0).toList(),
      2 => all.where((c) => c.validUntil.isBefore(now)).toList(),
      _ => all,
    };
  }

  Widget _buildStatusTab(int idx, String label) {
    final isSelected = _statusTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _statusTab = idx),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.dsPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.dsBodyMd.copyWith(
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.dsSurfaceContainerLowest
                    : AppColors.dsOnSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) =>
          ShimmerLoader(width: double.infinity, height: 130, borderRadius: 24),
    );
  }
}

// ─── Vertical Coupon Card (full width) ───────────────────────────────────────

class _VerticalCouponCard extends StatelessWidget {
  final HomeCouponEntity coupon;
  const _VerticalCouponCard({required this.coupon});

  static const _catColors = {
    'FOOD': Color(0xFF1C0A3E),
    'SALON': Color(0xFF064E3B),
    'THEATER': Color(0xFF7C2D12),
    'SPA': Color(0xFF1E3A5F),
    'CAFE': Color(0xFF3B1F6B),
    'OTHER': Color(0xFF374151),
  };

  static const _catIcons = {
    'FOOD': Icons.restaurant_rounded,
    'SALON': Icons.content_cut_rounded,
    'THEATER': Icons.movie_rounded,
    'SPA': Icons.spa_rounded,
    'CAFE': Icons.coffee_rounded,
    'OTHER': Icons.local_offer_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    final brandColor =
        _catColors[coupon.category] ?? const Color(0xFF374151);
    final brandIcon =
        _catIcons[coupon.category] ?? Icons.local_offer_rounded;

    return Container(
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
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand side
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.15),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(24)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.dsSurfaceContainerLowest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(brandIcon,
                              color: Color(brandColor.value),
                              size: 26),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            coupon.sellerName.toUpperCase(),
                            style: AppTextStyles.dsLabelMd.copyWith(
                              color: Color(brandColor.value),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Details side
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${coupon.discountPercent}% OFF',
                                style: AppTextStyles.dsDisplayLg.copyWith(
                                    fontSize: 24,
                                    color: AppColors.dsSecondaryMint),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.dsSecondaryMint,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                coupon.couponType,
                                style: AppTextStyles.dsLabelMd.copyWith(
                                  color: AppColors.dsSurfaceContainerLowest,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 12,
                                color:
                                    AppColors.dsOnSurface.withOpacity(0.45)),
                            const SizedBox(width: 3),
                            Text(
                              '${coupon.sellerArea} • ${coupon.category}',
                              style: AppTextStyles.dsLabelMd.copyWith(
                                color: AppColors.dsOnSurface.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        if (coupon.minSpend != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Min spend ₹${coupon.minSpend}',
                            style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.45),
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // Dashed divider
                        Row(
                          children: List.generate(
                            18,
                            (_) => Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height: 1,
                                color: AppColors.dsSurfaceContainerLow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('VALID TILL',
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                        fontSize: 9,
                                        color: AppColors.dsOnSurface
                                            .withOpacity(0.4))),
                                Text(fmt.format(coupon.validUntil),
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.dsTertiaryPink)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('USES LEFT',
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                        fontSize: 9,
                                        color: AppColors.dsOnSurface
                                            .withOpacity(0.4))),
                                Text('${coupon.usesRemaining} / ${coupon.maxUsesPerBook}',
                                    style: AppTextStyles.dsLabelMd.copyWith(
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
          ),
          // Punch outs
          Positioned(
            left: -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: AppColors.dsSurface, shape: BoxShape.circle),
              ),
            ),
          ),
          Positioned(
            right: -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: AppColors.dsSurface, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
