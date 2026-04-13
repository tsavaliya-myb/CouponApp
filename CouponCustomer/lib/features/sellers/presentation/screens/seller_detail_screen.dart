// lib/features/sellers/presentation/screens/seller_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/utils/category_utils.dart';
import '../../../home/domain/entities/home_coupon_entity.dart';
import '../../../home/domain/entities/nearby_seller_entity.dart';
import '../../../home/presentation/providers/home_provider.dart';

// ─── Provider: coupons filtered by sellerId ─────────────────────────────────

final sellerCouponsProvider =
    Provider.autoDispose.family<AsyncValue<List<HomeCouponEntity>>, String>(
  (ref, sellerId) {
    final allAsync = ref.watch(allCouponsProvider);
    return allAsync.whenData((all) =>
        all.where((c) => c.sellerId == sellerId && c.isUsable).toList()
          ..sort((a, b) => b.discountPercent.compareTo(a.discountPercent)));
  },
);

// ─── Screen ──────────────────────────────────────────────────────────────────

class SellerDetailScreen extends ConsumerWidget {
  final NearbySellerEntity seller;

  const SellerDetailScreen({super.key, required this.seller});

  Color get _accent => CategoryUtils.getBaseColor(seller.category);
  String get _emoji => CategoryUtils.getEmoji(seller.category);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(sellerCouponsProvider(seller.id));

    // --- Build unified media list: video first, then photos ---
    final media = seller.media;
    final photoUrls = <String>[
      if (media?.photoUrl1 != null && media!.photoUrl1!.isNotEmpty)
        media.photoUrl1!,
      if (media?.photoUrl2 != null && media!.photoUrl2!.isNotEmpty)
        media.photoUrl2!,
    ];
    final videoUrl = (media?.videoUrl != null && media!.videoUrl!.isNotEmpty)
        ? media.videoUrl!
        : null;
    final hasMedia = videoUrl != null || photoUrls.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      appBar: AppBar(
        backgroundColor: AppColors.dsSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.dsSurfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back_rounded,
                  size: 20, color: AppColors.dsOnSurface),
            ),
          ),
        ),
        title: Text(
          seller.name,
          style: AppTextStyles.dsTitleLg.copyWith(fontSize: 17),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        titleSpacing: 8,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // ── Unified Media Slider (video first, then photos) ─────────
          SliverToBoxAdapter(
            child: hasMedia
                ? _SellerMediaSlider(
                    videoUrl: videoUrl,
                    photoUrls: photoUrls,
                    accent: _accent,
                  )
                : _SellerMediaPlaceholder(emoji: _emoji, accent: _accent),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Seller Info Card ────────────────────────────────────────────
          SliverToBoxAdapter(
            child:
                _SellerInfoCard(seller: seller, accent: _accent, emoji: _emoji),
          ),

          // ── Active Coupons label ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Text('Active Coupons',
                      style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18)),
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
                      ) ??
                      const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // ── Coupon list ───────────────────────────────────────────────
          couponsAsync.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: ShimmerLoader(
                      width: double.infinity, height: 130, borderRadius: 24),
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
                                  color:
                                      AppColors.dsOnSurface.withOpacity(0.35))),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
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
                  ),
                  childCount: coupons.length,
                ),
              );
            },
          ),

          // ── Map Section ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SellerMapSection(seller: seller, accent: _accent),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

// ─── Unified Media Slider (video at index 0, photos after) ───────────────────
//
// Each page is its own StatefulWidget so that the VideoPlayerController is
// created and disposed exactly once per slide, avoiding texture-buffer leaks.
// The slider height is fixed at 320 dp to match the former photo-only slider.

class _SellerMediaSlider extends StatefulWidget {
  final String? videoUrl;
  final List<String> photoUrls;
  final Color accent;

  const _SellerMediaSlider({
    required this.videoUrl,
    required this.photoUrls,
    required this.accent,
  });

  @override
  State<_SellerMediaSlider> createState() => _SellerMediaSliderState();
}

class _SellerMediaSliderState extends State<_SellerMediaSlider> {
  int _currentPage = 0;

  // Notifies the video page whether it is the active (visible) slide.
  // When inactive the video pauses, releasing ImageReader frame buffers
  // and eliminating the "Unable to acquire a buffer item" ANR warning.
  final ValueNotifier<bool> _videoActive = ValueNotifier(true);

  /// Total slide count: 1 video (if present) + photos.
  int get _totalSlides =>
      (widget.videoUrl != null ? 1 : 0) + widget.photoUrls.length;

  @override
  void dispose() {
    _videoActive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            onPageChanged: (p) {
              setState(() => _currentPage = p);
              // Pause video when leaving slide 0; resume when returning.
              // This stops the MediaCodec decoder → frame buffers released →
              // ImageReader pool drains → no more buffer exhaustion warning.
              if (widget.videoUrl != null) {
                _videoActive.value = (p == 0);
              }
            },
            itemCount: _totalSlides,
            itemBuilder: (_, i) {
              // Index 0 → video slide (when videoUrl is provided)
              if (widget.videoUrl != null && i == 0) {
                return _SliderVideoPage(
                  videoUrl: widget.videoUrl!,
                  accent: widget.accent,
                  isActive: _videoActive,
                );
              }
              // Remaining indices → photos
              final photoIndex = widget.videoUrl != null ? i - 1 : i;
              return CachedNetworkImage(
                imageUrl: widget.photoUrls[photoIndex],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) => Container(
                  color: AppColors.dsSurfaceContainerLow,
                  child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.dsSurfaceContainerLow,
                  child: const Icon(Icons.broken_image_outlined, size: 40),
                ),
              );
            },
          ),
        ),

        // ── Indicator dots (shown when there's more than one slide) ────────
        if (_totalSlides > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalSlides,
                (i) {
                  final isVideo = widget.videoUrl != null && i == 0;
                  final isActive = _currentPage == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      // Video dot has a slight teal tint when inactive
                      color: isActive
                          ? Colors.white
                          : (isVideo
                              ? Colors.white.withOpacity(0.65)
                              : Colors.white.withOpacity(0.45)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Video slide inside PageView ──────────────────────────────────────────────
//
// Manages one VideoPlayerController. Video autoplays muted and loops.
// Using a dedicated StatefulWidget ensures dispose() fires when the page
// is removed from the tree, releasing the platform texture immediately.

class _SliderVideoPage extends StatefulWidget {
  final String videoUrl;
  final Color accent;

  /// Notifier from the parent slider: true = this slide is visible.
  final ValueNotifier<bool> isActive;

  const _SliderVideoPage({
    required this.videoUrl,
    required this.accent,
    required this.isActive,
  });

  @override
  State<_SliderVideoPage> createState() => _SliderVideoPageState();
}

// AutomaticKeepAliveClientMixin keeps this page alive in the PageView
// even when the user slides to another slide. Without this mixin, Flutter
// disposes the widget (and the VideoPlayerController) every time the page
// scrolls off-screen, forcing a fresh network load on every swipe-back.
class _SliderVideoPageState extends State<_SliderVideoPage>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _ctrl;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initVideo();
    widget.isActive.addListener(_onActiveChanged);
  }

  /// Called whenever the slider switches slides.
  void _onActiveChanged() {
    final ctrl = _ctrl;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (widget.isActive.value) {
      ctrl.play();
    } else {
      // Pause stops the MediaCodec decoder → frame buffers are released →
      // the ImageReader buffer pool drains, ending the buffer warning.
      ctrl.pause();
    }
  }

  Future<void> _initVideo() async {
    final ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await ctrl.initialize();
      await ctrl.setLooping(true);
      await ctrl.setVolume(0);
      if (mounted) {
        setState(() => _ctrl = ctrl);
        // Only autoplay if this slide is still active
        if (widget.isActive.value) ctrl.play();
      } else {
        ctrl.dispose();
      }
    } catch (_) {
      ctrl.dispose();
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    widget.isActive.removeListener(_onActiveChanged);
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin

    if (_hasError) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_rounded, size: 40, color: Colors.white38),
              SizedBox(height: 8),
              Text('Video unavailable',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final ctrl = _ctrl;
    if (ctrl == null || !ctrl.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child:
              CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
        ),
      );
    }

    final vw = ctrl.value.size.width;
    final vh = ctrl.value.size.height;
    if (vw == 0 || vh == 0) return Container(color: Colors.black);

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: vw,
          height: vh,
          child: VideoPlayer(ctrl),
        ),
      ),
    );
  }
}

// ─── Placeholder when no photos ──────────────────────────────────────────────

class _SellerMediaPlaceholder extends StatelessWidget {
  final String emoji;
  final Color accent;
  const _SellerMediaPlaceholder({required this.emoji, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(0.25),
            accent.withOpacity(0.08),
            AppColors.dsSurface,
          ],
          stops: const [0, 0.6, 1],
        ),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 72)),
      ),
    );
  }
}

// ─── Seller Info Card ─────────────────────────────────────────────────────────

class _SellerInfoCard extends StatelessWidget {
  final NearbySellerEntity seller;
  final Color accent;
  final String emoji;

  const _SellerInfoCard({
    required this.seller,
    required this.accent,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Logo centred ──────────────────────────────────────────
            _SellerAvatar(
              logoUrl: seller.logoUrl ?? seller.media?.logoUrl,
              emoji: emoji,
              accent: accent,
            ),
            const SizedBox(height: 14),

            // ── Seller name ──────────────────────────────────────────
            Text(
              seller.name,
              style: AppTextStyles.dsTitleLg.copyWith(fontSize: 19),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // ── Info grid (2 columns) ──────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    value: seller.category,
                    accent: accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.place_rounded,
                    label: 'Area',
                    value: seller.area,
                    accent: accent,
                  ),
                ),
              ],
            ),
            if (seller.distanceKm != null) ...[
              const SizedBox(height: 10),
              _InfoTile(
                icon: Icons.directions_walk_rounded,
                label: 'Distance',
                value: '${seller.distanceKm!.toStringAsFixed(1)} km away',
                accent: accent,
                fullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SellerAvatar extends StatelessWidget {
  final String? logoUrl;
  final String emoji;
  final Color accent;

  const _SellerAvatar(
      {required this.logoUrl, required this.emoji, required this.accent});

  @override
  Widget build(BuildContext context) {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.dsOnSurface.withOpacity(0.1), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: CachedNetworkImage(
            imageUrl: logoUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
                color: AppColors.dsSurfaceContainerLow,
                child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2))),
            errorWidget: (_, __, ___) => _buildEmoji(),
          ),
        ),
      );
    }
    return _buildEmoji();
  }

  Widget _buildEmoji() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withOpacity(0.18), accent.withOpacity(0.06)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.15), width: 1),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 30))),
    );
  }
}

// ─── Info tile (used inside _SellerInfoCard grid) ────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final bool fullWidth;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.dsLabelMd.copyWith(
                    fontSize: 10,
                    color: AppColors.dsOnSurface.withOpacity(0.45),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.dsLabelMd.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dsOnSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: accent),
              const SizedBox(width: 5),
              Text('Location',
                  style: AppTextStyles.dsLabelMd.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dsOnSurface.withOpacity(0.55),
                  )),
            ],
          ),
          const SizedBox(height: 8),

          // Compact map
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 140,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: point,
                      initialZoom: 15.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
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
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                          color: accent.withOpacity(0.45),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3))
                                    ],
                                  ),
                                  child: const Icon(Icons.storefront_rounded,
                                      size: 15, color: Colors.white),
                                ),
                                CustomPaint(
                                  size: const Size(10, 7),
                                  painter: _PinTailPainter(color: accent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // "Open in Maps" button overlaid bottom-right
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _openInGoogleMaps(
                          seller.lat, seller.lng, seller.name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new_rounded,
                                size: 11, color: accent),
                            const SizedBox(width: 4),
                            Text(
                              'Open in Maps',
                              style: TextStyle(
                                color: accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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

// ─── Coupon Card ─────────────────────────────────────────────────────────────

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
                              fontSize: 28, color: AppColors.dsSecondaryMint),
                        ),
                      ),
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
                        value:
                            '${coupon.usesRemaining} / ${coupon.maxUsesPerBook}',
                        valueColor: AppColors.dsOnSurface,
                        alignRight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        ),
      ),
    );
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
                fontSize: 9, color: AppColors.dsOnSurface.withOpacity(0.4))),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.dsLabelMd
                .copyWith(fontWeight: FontWeight.w800, color: valueColor)),
      ],
    );
  }
}
