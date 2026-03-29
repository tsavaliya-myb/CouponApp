// lib/features/sellers/presentation/screens/seller_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/utils/category_utils.dart';
import '../../../home/domain/entities/home_coupon_entity.dart';
import '../../../home/domain/entities/nearby_seller_entity.dart';
import '../../../home/presentation/providers/home_provider.dart';

// ─── Provider: coupons filtered by sellerId ────────────────────────────────────

final sellerCouponsProvider =
    Provider.autoDispose.family<AsyncValue<List<HomeCouponEntity>>, String>(
  (ref, sellerId) {
    final allAsync = ref.watch(allCouponsProvider);
    return allAsync.whenData((all) => all
        .where((c) => c.sellerId == sellerId && c.isUsable)
        .toList()
      ..sort((a, b) => b.discountPercent.compareTo(a.discountPercent)));
  },
);

// ─── Screen ───────────────────────────────────────────────────────────────────

class SellerDetailScreen extends ConsumerWidget {
  final NearbySellerEntity seller;

  const SellerDetailScreen({super.key, required this.seller});

  Color get _accent => CategoryUtils.getBaseColor(seller.category);

  String get _emoji => CategoryUtils.getEmoji(seller.category);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(sellerCouponsProvider(seller.id));

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ─────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.dsSurface,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.dsSurfaceContainerLow.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      size: 20, color: AppColors.dsOnSurface),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _accent.withOpacity(0.2),
                      _accent.withOpacity(0.05),
                      AppColors.dsSurface,
                    ],
                    stops: const [0, 0.6, 1],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Brand circle
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _accent.withOpacity(0.25), width: 2),
                      ),
                      child: Center(
                        child: Text(_emoji,
                            style: const TextStyle(fontSize: 36)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      seller.name,
                      style: AppTextStyles.dsTitleLg.copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            seller.category,
                            style: AppTextStyles.dsLabelMd.copyWith(
                              color: _accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.location_on,
                            size: 12,
                            color: AppColors.dsOnSurface.withOpacity(0.45)),
                        const SizedBox(width: 2),
                        Text(
                          seller.area,
                          style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.55)),
                        ),
                        if (seller.distanceKm != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.dsSurfaceContainerLow,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              '${seller.distanceKm!.toStringAsFixed(1)} km',
                              style: AppTextStyles.dsLabelMd.copyWith(
                                  fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Map Section ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SellerMapSection(seller: seller, accent: _accent),
          ),

          // ── Section label ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Text('Active Coupons',
                      style:
                          AppTextStyles.dsTitleLg.copyWith(fontSize: 18)),
                  const SizedBox(width: 8),
                  couponsAsync.whenOrNull(
                    data: (list) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.dsSecondaryMint.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${list.length}',
                        style: AppTextStyles.dsLabelMd.copyWith(
                          color: AppColors.dsSecondaryMint,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ) ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // ── Coupon list ───────────────────────────────────────────────────
          couponsAsync.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding:
                      const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: ShimmerLoader(
                      width: double.infinity,
                      height: 130,
                      borderRadius: 24),
                ),
                childCount: 3,
              ),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Text('Could not load coupons',
                      style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.4))),
                ),
              ),
            ),
            data: (coupons) {
              if (coupons.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.confirmation_number_outlined,
                              size: 48,
                              color: AppColors.dsOnSurface.withOpacity(0.15)),
                          const SizedBox(height: 12),
                          Text('No active coupons from this seller',
                              style: AppTextStyles.dsBodyMd.copyWith(
                                  color: AppColors.dsOnSurface
                                      .withOpacity(0.35))),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    return Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      child: _SellerCouponCard(
                          coupon: coupons[i],
                          onTap: () => context.push(
                            '/coupon-detail',
                            extra: coupons[i],
                          ),
                        )
                          .animate()
                          .fadeIn(
                              duration: 300.ms,
                              delay: Duration(milliseconds: 50 * i))
                          .slideY(begin: 0.04),
                    );
                  },
                  childCount: coupons.length,
                ),
              );
            },
          ),

          // bottom padding so last card clears the nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

// ─── Map Section ─────────────────────────────────────────────────────────────

Future<void> _openInGoogleMaps(double lat, double lng, String name) async {
  final encoded = Uri.encodeComponent(name);
  final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$encoded');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SellerMapSection extends StatelessWidget {
  final NearbySellerEntity seller;
  final Color accent;

  const _SellerMapSection({required this.seller, required this.accent});

  @override
  Widget build(BuildContext context) {
    final point = LatLng(seller.lat, seller.lng);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: accent),
              const SizedBox(width: 6),
              Text('Location',
                  style: AppTextStyles.dsTitleLg.copyWith(fontSize: 16)),
              const Spacer(),
              // Open in Google Maps button
              GestureDetector(
                onTap: () => _openInGoogleMaps(
                    seller.lat, seller.lng, seller.name),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withOpacity(0.75)],
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.open_in_new_rounded,
                          size: 12, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        'Open in Maps',
                        style: AppTextStyles.dsLabelMd.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Map ──────────────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 180,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: point,
                      initialZoom: 15.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none, // static — no drag/zoom
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.couponapp.customer',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: point,
                            width: 48,
                            height: 56,
                            child: Column(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accent.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.storefront_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                CustomPaint(
                                  size: const Size(12, 8),
                                  painter: _PinTailPainter(color: accent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Subtle gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.dsSurface.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Triangle tail for the map pin marker
class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color;
}

// ─── Coupon Card (seller detail variant) ──────────────────────────────────────

class _SellerCouponCard extends StatelessWidget {
  final HomeCouponEntity coupon;
  final VoidCallback? onTap;
  const _SellerCouponCard({required this.coupon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${coupon.discountPercent}% OFF',
                        style: AppTextStyles.dsDisplayLg.copyWith(
                            fontSize: 28,
                            color: AppColors.dsSecondaryMint),
                      ),
                    ),
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dsPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        coupon.couponType,
                        style: AppTextStyles.dsLabelMd.copyWith(
                          color: AppColors.dsPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                if (coupon.minSpend != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Min spend ₹${coupon.minSpend}',
                    style: AppTextStyles.dsBodyMd.copyWith(
                      color: AppColors.dsOnSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Dashed line
                Row(
                  children: List.generate(
                    22,
                    (_) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 1,
                        color: AppColors.dsSurfaceContainerLow,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoChip(
                        label: 'VALID TILL',
                        value: fmt.format(coupon.validUntil),
                        valueColor: AppColors.dsTertiaryPink),
                    _InfoChip(
                      label: 'USES LEFT',
                      value: '${coupon.usesRemaining} / ${coupon.maxUsesPerBook}',
                      valueColor: AppColors.dsOnSurface,
                      alignRight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // punch-outs
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
              )),
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
              )),
        ],
      ),  // Stack
      ),  // Container
    );  // GestureDetector
  }
}

class _InfoChip extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  final bool alignRight;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.valueColor,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.dsLabelMd.copyWith(
                fontSize: 9,
                color: AppColors.dsOnSurface.withOpacity(0.4))),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.dsLabelMd.copyWith(
                fontWeight: FontWeight.w800, color: valueColor)),
      ],
    );
  }
}
