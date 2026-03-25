// lib/features/coupons/presentation/screens/my_coupons_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../home/domain/entities/home_coupon_entity.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../../core/widgets/coupon_card.dart';

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
            // ── Status Tabs (Active / Used / Expired) ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 65),
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
                    onTap: () =>
                        ref.read(selectedCategoryProvider.notifier).state = key,
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
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
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
                              color: AppColors.dsOnSurface.withOpacity(0.2)),
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
                      return CouponCard(
                        coupon: coupons[i],
                        showUsesLeft: true,
                        onTap: () => context.push(
                          '/coupon-detail',
                          extra: coupons[i],
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 300.ms,
                            delay: Duration(milliseconds: 40 * i),
                          )
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
      0 => all
          .where((c) => c.status == 'ACTIVE' && c.validUntil.isAfter(now))
          .toList(),
      1 => all.where((c) => c.status == 'USED').toList(),
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
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
          ShimmerLoader(width: double.infinity, height: 120, borderRadius: 24),
    );
  }
}
