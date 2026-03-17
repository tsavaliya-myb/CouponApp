// lib/features/home/presentation/screens/home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../providers/home_provider.dart';

// ─── Home Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  int _navIndex = 0;

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
      backgroundColor: AppColors.bgPage,
      body: RefreshIndicator(
        color: AppColors.primaryAccent,
        onRefresh: () async {
          await ref.read(featuredCouponsProvider.notifier).refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Top Safe Area padding ──────────────────────────────────────
            const SliverToBoxAdapter(child: _TopSafeAreaSpacer()),
            // ── Header ────────────────────────────────────────────────────
            const SliverToBoxAdapter(child: _HomeHeader()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),
            // ── Category Tabs ─────────────────────────────────────────────
            const SliverToBoxAdapter(child: _CategoryTabs()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),
            // ── Featured Coupons ──────────────────────────────────────────
            const SliverToBoxAdapter(child: _FeaturedCouponsSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),
            // ── Deals Nearby ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Text('Deals near you', style: AppTextStyles.heading2),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sm),
            ),
            const _NearbySellersSection(),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Bottom nav buffer
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ─── Top Safe Area ────────────────────────────────────────────────────────────

class _TopSafeAreaSpacer extends StatelessWidget {
  const _TopSafeAreaSpacer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.top + AppSpacing.md);
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Alex 👋',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                const SizedBox(height: 2),
                Text(
                  'Find amazing deals near you',
                  style: AppTextStyles.bodySmall,
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              ],
            ),
          ),
          // Search icon
          _IconCircleButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(width: AppSpacing.sm),
          // Profile avatar
          _ProfileAvatar().animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryAccent, width: 2),
        ),
        child: ClipOval(
          child: Container(
            color: AppColors.primarySoft,
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primaryAccent,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Category Tabs ────────────────────────────────────────────────────────────

const _kCategories = [
  ('popular', 'Popular'),
  ('food', 'Food'),
  ('salon', 'Salon'),
  ('retail', 'Retail'),
  ('cafe', 'Café'),
  ('spa', 'Spa'),
  ('theater', 'Theater'),
];

class _CategoryTabs extends ConsumerWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _kCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (key, label) = _kCategories[i];
          final isSelected = selected == key;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: GestureDetector(
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = key;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.textOnDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Featured Coupons Section ─────────────────────────────────────────────────

class _FeaturedCouponsSection extends ConsumerWidget {
  const _FeaturedCouponsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(featuredCouponsProvider);

    return couponsAsync.when(
      loading: () => _buildShimmer(),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Failed to load coupons',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ),
      data: (coupons) {
        if (coupons.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Text(
                  'No coupons available',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            itemCount: coupons.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) =>
                FeaturedCouponCard(coupon: coupons[i])
                    .animate()
                    .fadeIn(
                      duration: 350.ms,
                      delay: Duration(milliseconds: 60 * i),
                    )
                    .slideY(begin: 0.06),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => ShimmerLoader(
          width: 280,
          height: 200,
          borderRadius: 20,
        ),
      ),
    );
  }
}

// ─── Featured Coupon Card ─────────────────────────────────────────────────────

class FeaturedCouponCard extends StatelessWidget {
  final HomeCouponEntity coupon;

  const FeaturedCouponCard({super.key, required this.coupon});

  Color get _bgColor => AppColors.forCategory(coupon.category);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _bgColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative blob
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Coupon notch left
          Positioned(
            left: -1,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.bgPage,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // Coupon notch right
          Positioned(
            right: -1,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.bgPage,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Discount headline
                Text(
                  '${coupon.discountPercent}% off',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                // Seller name
                Text(
                  coupon.sellerName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.90),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Min spend
                if (coupon.minSpend != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'on orders above ₹${coupon.minSpend}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.70),
                    ),
                  ),
                ],
                const Spacer(),
                // Dashed divider
                Row(
                  children: List.generate(
                    24,
                    (_) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 1,
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Validity
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: Colors.white.withOpacity(0.65),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'VALID ${dateFormat.format(coupon.validFrom)} – ${dateFormat.format(coupon.validUntil)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.white.withOpacity(0.70),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        coupon.category.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
            padding: const EdgeInsets.only(
              left: AppSpacing.screenPadding,
              right: AppSpacing.screenPadding,
              bottom: 12,
            ),
            child: ShimmerLoader(
              width: double.infinity,
              height: 90,
              borderRadius: 16,
            ),
          ),
          childCount: 4,
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Text(
            'Failed to load sellers',
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ),
      ),
      data: (sellers) {
        if (sellers.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Text(
                'No sellers nearby',
                style: AppTextStyles.bodySmall,
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
                bottom: 12,
              ),
              child: NearbySellerCard(seller: sellers[i])
                  .animate()
                  .fadeIn(
                    duration: 300.ms,
                    delay: Duration(milliseconds: 50 * i),
                  )
                  .slideY(begin: 0.05),
            ),
            childCount: sellers.length,
          ),
        );
      },
    );
  }
}

// ─── Nearby Seller Card ───────────────────────────────────────────────────────

class NearbySellerCard extends StatelessWidget {
  final NearbySellerEntity seller;

  const NearbySellerCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Seller image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: seller.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: seller.imageUrl!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => ShimmerLoader(
                          width: 70,
                          height: 70,
                          borderRadius: 12,
                        ),
                        errorWidget: (_, __, ___) =>
                            _CategoryPlaceholder(category: seller.category),
                        memCacheWidth: 140,
                        memCacheHeight: 140,
                      )
                    : _CategoryPlaceholder(category: seller.category),
              ),
              // Badge
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    seller.bestCouponLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.name,
                  style: AppTextStyles.heading3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${seller.category} • ${seller.area} • ${seller.distanceKm.toStringAsFixed(1)} km',
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      seller.rating.toStringAsFixed(1),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${seller.totalRatings}+)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Chevron
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
          ),
        ],
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
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.forCategory(category).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(_emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Coupons',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.bookmark_border_rounded,
                label: 'Saved',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.primaryAccent
                      : AppColors.textHint,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primaryAccent
                      : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
