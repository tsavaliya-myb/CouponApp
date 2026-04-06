// lib/features/home/presentation/screens/home_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/subscribe_bottom_sheet.dart';
import '../providers/home_provider.dart';
import '../../../../core/widgets/coupon_card.dart';
import '../../../../core/widgets/seller_card.dart';
import 'package:couponcode/features/profile/presentation/providers/profile_provider.dart';

// ─── Home Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(nearbySellersProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isSubscribed = ref.watch(isSubscribedProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: RefreshIndicator(
        color: AppColors.dsPrimary,
        backgroundColor: AppColors.dsSurfaceContainerLowest,
        onRefresh: () async {
          if (isSubscribed) {
            await ref.read(allCouponsProvider.notifier).refresh();
          }
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // ── Header (Greeting & Search) ────────────────────────────────
            const SliverToBoxAdapter(child: _HomeHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            // ── Category Tabs ─────────────────────────────────────────────
            const SliverToBoxAdapter(child: _CategoryTabs()),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            // ── Active Coupons (Ticket Cards) ──────────────────────────────
            SliverToBoxAdapter(
              child: isSubscribed
                  ? const _ActiveCouponsSection()
                  : const _MockCouponsSection(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            // ── Top Sellers in Adajan ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Sellers Near You',
                        style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
                    if (isSubscribed)
                      GestureDetector(
                        onTap: () => context.go('/sellers'),
                        child: Text(
                          'View All',
                          style: AppTextStyles.dsLabelMd.copyWith(
                            color: AppColors.dsPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (isSubscribed)
              const _NearbySellersSection()
            else
              const _MockSellersSection(),
            const SliverToBoxAdapter(
              child: SizedBox(height: 120), // Bottom nav buffer
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final displayName = profileAsync.when(
      data: (user) =>
          (user.name != null && user.name!.isNotEmpty) ? user.name : 'Friend',
      error: (_, __) => 'Friend',
      loading: () => '...',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hello, $displayName!',
            style: AppTextStyles.dsDisplayLg.copyWith(fontSize: 24),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          Text(
            'Ready to save?',
            style: AppTextStyles.dsBodyMd.copyWith(
              color: AppColors.dsOnSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
        ],
      ),
    );
  }
}

// ─── Category Tabs ────────────────────────────────────────────────────────────

const _kCategories = [
  ('ALL', 'All', Icons.grid_view_rounded),
  ('FOOD', 'Food', Icons.restaurant_rounded),
  ('CAFE', 'Cafe', Icons.coffee_rounded),
  ('SALON', 'Salon', Icons.content_cut_rounded),
  ('THEATER', 'Theater', Icons.movie_rounded),
  ('SPA', 'Spa', Icons.spa_rounded),
];

class _CategoryTabs extends ConsumerWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories',
                  style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _kCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final (key, label, icon) = _kCategories[i];
              final isSelected = selected == key;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).state = key;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.dsPrimary
                        : AppColors.dsSurfaceContainerLow,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isSelected
                            ? AppColors.dsSurfaceContainerLowest
                            : AppColors.dsPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Active Coupons Section (Subscribed) ──────────────────────────────────────

class _ActiveCouponsSection extends ConsumerWidget {
  const _ActiveCouponsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(featuredCouponsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text('Your Active Coupons',
                  style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/coupons'),
                child: Text(
                  'View All',
                  style: AppTextStyles.dsLabelMd.copyWith(
                    color: AppColors.dsPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        couponsAsync.when(
          loading: () => _buildShimmer(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Failed to load coupons',
                style: AppTextStyles.dsBodyMd
                    .copyWith(color: AppColors.dsTertiaryPink)),
          ),
          data: (coupons) {
            if (coupons.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildEmptyCoupon(),
              );
            }
            final preview = coupons.take(3).toList();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: preview.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                return CouponCard(
                  coupon: preview[i],
                  showUsesLeft: true,
                  onTap: () => context.push(
                    '/coupon-detail',
                    extra: preview[i],
                  ),
                )
                    .animate()
                    .fadeIn(
                        duration: 350.ms, delay: Duration(milliseconds: 60 * i))
                    .slideY(begin: 0.05);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => ShimmerLoader(
        width: double.infinity,
        height: 120,
        borderRadius: 24,
      ),
    );
  }

  Widget _buildEmptyCoupon() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_number_rounded,
              size: 56, color: AppColors.dsOnSurface.withOpacity(0.15)),
          const SizedBox(height: 16),
          Text('No coupons found',
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

// ─── Mock Coupons Section (Non-Subscribed) ────────────────────────────────────

class _MockCouponsSection extends StatelessWidget {
  const _MockCouponsSection();

  @override
  Widget build(BuildContext context) {
    final blurred = blurredCouponIndices.toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text('Your Active Coupons',
                  style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.dsPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'SUBSCRIBE TO UNLOCK',
                  style: AppTextStyles.dsLabelMd.copyWith(
                    color: AppColors.dsPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: mockCoupons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, i) {
            final isBlurred = blurred.contains(i);
            return CouponCard(
              coupon: mockCoupons[i],
              showUsesLeft: false,
              isBlurred: isBlurred,
              onTap: () => showSubscribeBottomSheet(context),
            )
                .animate()
                .fadeIn(
                    duration: 350.ms, delay: Duration(milliseconds: 60 * i))
                .slideY(begin: 0.05);
          },
        ),
      ],
    );
  }
}

// ─── Nearby Sellers Section (Subscribed) ──────────────────────────────────────

class _NearbySellersSection extends ConsumerWidget {
  const _NearbySellersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellersAsync = ref.watch(homeFilteredSellersProvider);

    return sellersAsync.when(
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: ShimmerLoader(
                width: double.infinity, height: 110, borderRadius: 24),
          ),
          childCount: 4,
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Failed to load sellers',
              style: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsTertiaryPink)),
        ),
      ),
      data: (sellers) {
        if (sellers.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptySeller(),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
              child: SellerCard(
                seller: sellers[i],
                onTap: () => context.push(
                  '/seller-detail',
                  extra: sellers[i],
                ),
              )
                  .animate()
                  .fadeIn(
                      duration: 300.ms, delay: Duration(milliseconds: 50 * i))
                  .slideY(begin: 0.05),
            ),
            childCount: sellers.length,
          ),
        );
      },
    );
  }

  Widget _buildEmptySeller() {
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

// ─── Mock Sellers Section (Non-Subscribed) ────────────────────────────────────

class _MockSellersSection extends StatelessWidget {
  const _MockSellersSection();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
          child: SellerCard(
            seller: mockSellers[i],
            onTap: () => showSubscribeBottomSheet(context),
          )
              .animate()
              .fadeIn(
                  duration: 300.ms, delay: Duration(milliseconds: 50 * i))
              .slideY(begin: 0.05),
        ),
        childCount: mockSellers.length,
      ),
    );
  }
}
