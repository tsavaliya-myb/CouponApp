// lib/features/sellers/presentation/screens/sellers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/seller_card.dart';

import '../../../home/presentation/providers/home_provider.dart';

// ─── Categories ───────────────────────────────────────────────────────────────

const _kSellerCategories = [
  ('ALL', 'All'),
  ('FOOD', 'Food'),
  ('CAFE', 'Cafe'),
  ('SALON', 'Salon'),
  ('THEATER', 'Theater'),
  ('SPA', 'Spa'),
  ('OTHER', 'Other'),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class SellersScreen extends ConsumerStatefulWidget {
  const SellersScreen({super.key});

  @override
  ConsumerState<SellersScreen> createState() => _SellersScreenState();
}

class _SellersScreenState extends ConsumerState<SellersScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(nearbySellersProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sellersAsync = ref.watch(filteredSellersProvider);
    final selectedCategory = ref.watch(selectedSellerCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Title ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Sellers Near You',
                style: AppTextStyles.dsTitleLg.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Discover top-rated local businesses',
                style: AppTextStyles.dsBodyMd
                    .copyWith(color: AppColors.dsOnSurface.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 20),

            // ── Category chips ───────────────────────────────────────────────
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _kSellerCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final (key, label) = _kSellerCategories[i];
                  final isSelected = selectedCategory == key;
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedSellerCategoryProvider.notifier).state =
                          key;
                    },
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

            // ── List ─────────────────────────────────────────────────────────
            Expanded(
              child: sellersAsync.when(
                loading: () => _buildShimmer(),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          size: 48,
                          color: AppColors.dsOnSurface.withOpacity(0.2)),
                      const SizedBox(height: 12),
                      Text('Could not load sellers',
                          style: AppTextStyles.dsBodyMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.4))),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => ref.invalidate(nearbySellersProvider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.dsSurfaceContainerLow,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text('Retry',
                              style: AppTextStyles.dsLabelMd
                                  .copyWith(color: AppColors.dsPrimary)),
                        ),
                      ),
                    ],
                  ),
                ),
                data: (sellers) {
                  if (sellers.isEmpty) return _buildEmpty();
                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    itemCount: sellers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) {
                      return SellerCard(
                            seller: sellers[i],
                            onTap: () => context.push(
                              '/seller-detail',
                              extra: sellers[i],
                            ),
                          )
                          .animate()
                          .fadeIn(
                              duration: 300.ms,
                              delay: Duration(milliseconds: 40 * i.clamp(0, 8)))
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

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) =>
          ShimmerLoader(width: double.infinity, height: 120, borderRadius: 24),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_outlined,
              size: 56, color: AppColors.dsOnSurface.withOpacity(0.15)),
          const SizedBox(height: 16),
          Text('No sellers found',
              style: AppTextStyles.dsTitleLg
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.4))),
          const SizedBox(height: 4),
          Text('Try a different category',
              style: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.3))),
        ],
      ),
    );
  }
}
