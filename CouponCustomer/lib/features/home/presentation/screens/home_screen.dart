// lib/features/home/presentation/screens/home_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../providers/home_provider.dart';
import '../../../coupons/presentation/screens/my_coupons_screen.dart';

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
    return Scaffold(
      backgroundColor: AppColors.dsSurface, // #FDF3FF
      extendBody: true, // Needed for floating authentic glass bottom nav
      body: RefreshIndicator(
        color: AppColors.dsPrimary,
        backgroundColor: AppColors.dsSurfaceContainerLowest,
        onRefresh: () async {
          await ref.read(allCouponsProvider.notifier).refresh();
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
            const SliverToBoxAdapter(child: _ActiveCouponsSection()),
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
                    Text('Top Sellers in Adajan',
                        style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dsSurfaceContainerLow,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.near_me_rounded,
                              size: 12,
                              color: AppColors.dsOnSurface.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text('Surat',
                              style: AppTextStyles.dsLabelMd.copyWith(
                                  color:
                                      AppColors.dsOnSurface.withOpacity(0.8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const _NearbySellersSection(),
            const SliverToBoxAdapter(
              child: SizedBox(height: 120), // Bottom nav buffer
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, Aarav!',
            style: AppTextStyles.dsDisplayLg,
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          const SizedBox(height: 4),
          Text(
            'Ready for your next celebration?',
            style: AppTextStyles.dsBodyMd
                .copyWith(color: AppColors.dsOnSurface.withOpacity(0.6)),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 10),
          // Search Bar
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.dsSurfaceContainerLow,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    color: AppColors.dsOnSurface.withOpacity(0.5)),
                const SizedBox(width: 0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search sellers or coupons...',
                      hintStyle: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.5)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                    ),
                    style: AppTextStyles.dsBodyMd,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms),
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
              Text('View All',
                  style: AppTextStyles.dsLabelMd.copyWith(
                      color: AppColors.dsPrimary, fontWeight: FontWeight.w700)),
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

// ─── Active Coupons Section (Ticket Style) ────────────────────────────────────

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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MyCouponsScreen()),
                ),
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
                child: Text('No coupons in this category',
                    style: AppTextStyles.dsBodyMd),
              );
            }
            final preview = coupons.take(3).toList();
            return SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: preview.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) {
                  return TicketCouponCard(coupon: preview[i])
                      .animate()
                      .fadeIn(
                          duration: 350.ms,
                          delay: Duration(milliseconds: 60 * i))
                      .slideY(begin: 0.05);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => ShimmerLoader(
          width: 320,
          height: 170,
          borderRadius: 24,
        ),
      ),
    );
  }
}

class TicketCouponCard extends StatelessWidget {
  final HomeCouponEntity coupon;

  const TicketCouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      width: 320,
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.04), // Ambient shadow
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
                decoration: const BoxDecoration(
                  color: AppColors.dsSurfaceContainerHighest,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(24)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.dsSurfaceContainerLowest,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.coffee,
                            color: AppColors.dsPrimary), // Placeholder icon
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          coupon.sellerName.toUpperCase(),
                          style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Right side (Details)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              'VERIFIED',
                              style: AppTextStyles.dsLabelMd.copyWith(
                                color: AppColors.dsSecondaryMint,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Premium Deal Selection',
                        style: AppTextStyles.dsTitleLg.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 12,
                              color: AppColors.dsOnSurface.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Text(
                            'Local Venue',
                            style: AppTextStyles.dsLabelMd.copyWith(
                                color: AppColors.dsOnSurface.withOpacity(0.5)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Dashed line internal horizontal
                      Row(
                        children: List.generate(
                          20,
                          (_) => Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.5),
                              height: 1,
                              color: AppColors.dsSurfaceContainerHighest,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('VALID TILL',
                                  style: AppTextStyles.dsLabelMd.copyWith(
                                      fontSize: 9,
                                      color: AppColors.dsOnSurface
                                          .withOpacity(0.4))),
                              Text(
                                  dateFormat
                                      .format(coupon.validUntil)
                                      .toUpperCase(),
                                  style: AppTextStyles.dsLabelMd.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.dsTertiaryPink)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.dsPrimary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Redeem',
                              style: AppTextStyles.dsLabelMd.copyWith(
                                  color: AppColors.dsSurfaceContainerLowest,
                                  fontWeight: FontWeight.w700),
                            ),
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
            top: 73,
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
            top: 73,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.dsSurface,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// ─── Nearby Sellers Section (Sliver) ─────────────────────────────────────────

class _NearbySellersSection extends ConsumerWidget {
  const _NearbySellersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellersAsync = ref.watch(nearbySellersProvider);

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('No sellers nearby', style: AppTextStyles.dsBodyMd),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
              child: NearbySellerCard(seller: sellers[i])
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
}

// ─── Nearby Seller Card Editorial ───────────────────────────────────────────────

class NearbySellerCard extends StatelessWidget {
  final NearbySellerEntity seller;

  const NearbySellerCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.04), // Ambient shadows
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left large image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _CategoryPlaceholder(category: seller.category),
            ),
            const SizedBox(width: 16),
            // Right info
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
                          style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (seller.distanceKm != null)
                        Text(
                          '${seller.distanceKm!.toStringAsFixed(1)} km',
                          style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.5)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${seller.category} • ${seller.area}',
                    style: AppTextStyles.dsLabelMd.copyWith(
                        color: AppColors.dsOnSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 16),

                  // Green Mint Save Badge Placeholder until deals are fetched
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.dsSurfaceContainerLow, // Use low surface
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Top Rated',
                          style: AppTextStyles.dsLabelMd.copyWith(
                            color: AppColors.dsSecondaryMint,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPlaceholder extends StatelessWidget {
  final String category;

  const _CategoryPlaceholder({required this.category});

  String get _emoji {
    return switch (category.toLowerCase()) {
      'food' => '🍔',
      'salon' => '💈',
      'theater' => '🎭',
      'spa' => '🛁',
      'cafe' => '☕',
      _ => '🏪',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(_emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
