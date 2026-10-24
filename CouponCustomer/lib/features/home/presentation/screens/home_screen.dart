// lib/features/home/presentation/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/navigation/app_route_observer.dart';
import '../../../../core/providers/navigation_provider.dart';
import '../providers/home_provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/models/category_item.dart';
import '../../../../core/utils/category_utils.dart';
import '../../domain/entities/banner_ad_entity.dart';
import 'package:Coupon360/features/profile/presentation/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

// ─── Home Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final _scrollController = ScrollController();

  // True while Home is the top-most route (false when a detail page or a
  // modal sheet is pushed on top). Combined with the active tab index this
  // tells the banner slider whether its video should hold a decoder.
  bool _routeVisible = true;
  ModalRoute<dynamic>? _route;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != _route) {
      if (_route != null) appRouteObserver.unsubscribe(this);
      _route = route;
      if (route != null) appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPushNext() => setState(() => _routeVisible = false);

  @override
  void didPopNext() => setState(() => _routeVisible = true);

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Prefetch both datasets in the background as soon as home screen mounts.
    ref.watch(allCouponsProvider);
    ref.watch(allSellersProvider);

    final isHomeVisible =
        ref.watch(currentTabIndexProvider) == 0 && _routeVisible;

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            // ── Gradient hero: Header + Banner ───────────────────────────
            SliverToBoxAdapter(
              child: Builder(
                builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFD4920A),
                        const Color(0xFFEFBF3C),
                        const Color(0xFFFFF3C2),
                        AppColors.dsSurface.withValues(alpha: 0.6),
                        AppColors.dsSurface.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.4, 0.78, 0.92, 1.0],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const _HomeHeader(),
                      const SizedBox(height: 10),
                      _BannerSlider(visible: isHomeVisible),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            // ── Category Tabs ─────────────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            const SliverToBoxAdapter(child: _CategoryTabs()),
            // -- Bottom nav bar buffer ------------------------------------------
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 80,
              ),
            ),
            // ── Active Coupons (Ticket Cards) ──────────────────────────────
            /*SliverToBoxAdapter(
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
            ),*/
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
            style: AppTextStyles.dsDisplayLg.copyWith(
              fontSize: 24,
              color: const Color(0xFF3B2200),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          Text(
            'Ready to save?',
            style: AppTextStyles.dsBodyMd.copyWith(
              color: const Color(0xFF3B2200).withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
        ],
      ),
    );
  }
}

// ─── Banner Slider ─────────────────────────────────────────────────────────────
// Fetches active ads from the API for the user's city and auto-scrolls them.
// Falls back to two branded placeholders when no ads are available.

class _BannerSlider extends ConsumerStatefulWidget {
  /// Whether Home is actually on screen (correct tab + top-most route).
  /// When false the slider releases its video decoder instead of just pausing.
  final bool visible;

  const _BannerSlider({required this.visible});

  @override
  ConsumerState<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends ConsumerState<_BannerSlider>
    with WidgetsBindingObserver {
  final _pageCtrl = PageController();
  int _current = 0;

  // Single VideoPlayerController — only ONE decoder surface at a time.
  VideoPlayerController? _videoCtrl;
  bool _videoInitialized = false;
  String? _loadedUrl;
  bool _isMuted = true; // persists across slide / tab changes

  // Generation token: incremented whenever a load becomes stale.
  // In-flight initializations check this and self-dispose if outdated.
  int _loadGen = 0;
  bool _initialLoadRequested = false; // ensures first load fires only once
  String? _failedUrl; // skip URLs that already caused a codec/OOM error

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant _BannerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible == widget.visible) return;
    if (!widget.visible) {
      // Home hidden: drop the decoder + buffers entirely.
      _loadGen++;
      _releaseVideo();
    } else {
      // Home visible again: reload the current slide's video.
      final ads =
          ref.read(bannerAdsProvider).valueOrNull ?? const <BannerAdEntity>[];
      // Let build() schedule the load if ads haven't arrived yet.
      _initialLoadRequested = ads.isNotEmpty;
      _loadVideoForIndex(_current, ads);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _videoCtrl?.pause();
    } else if (widget.visible) {
      _videoCtrl?.play();
    }
  }

  // Load (or resume) video for the slide at [index].
  // Uses a generation token so that stale in-flight inits self-dispose.
  Future<void> _loadVideoForIndex(int index, List<BannerAdEntity> ads) async {
    if (!mounted || !widget.visible || index >= ads.length) return;
    final url = ads[index].videoUrl;

    if (url == null || url.isEmpty) {
      _loadGen++;
      _releaseVideo();
      return;
    }
    if (url == _loadedUrl && _videoCtrl != null) {
      // Same URL already loaded: just resume.
      _videoCtrl!.setVolume(_isMuted ? 0.0 : 1.0);
      _videoCtrl!.play();
      return;
    }
    // Skip URLs that already caused a codec / OOM failure.
    if (url == _failedUrl) return;

    // Stamp this attempt. Any older in-flight load is now stale.
    final gen = ++_loadGen;
    _releaseVideo(); // free current decoder BEFORE creating a new one

    final ctrl = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    try {
      await ctrl.initialize();
    } catch (_) {
      // Codec / OOM failure: dispose, memo the URL so we never retry it.
      await ctrl.dispose();
      if (gen == _loadGen) _failedUrl = url;
      return;
    }
    // Stale (user swiped / disposed) or unmounted: discard immediately.
    if (!mounted || gen != _loadGen) {
      await ctrl.dispose();
      return;
    }
    ctrl.setLooping(true);
    ctrl.setVolume(_isMuted ? 0.0 : 1.0);
    ctrl.play();
    setState(() {
      _videoCtrl = ctrl;
      _videoInitialized = true;
      _loadedUrl = url;
    });
  }

  void _releaseVideo() {
    _videoCtrl?.pause();
    _videoCtrl?.dispose();
    if (mounted) {
      setState(() {
        _videoCtrl = null;
        _videoInitialized = false;
        _loadedUrl = null;
      });
    } else {
      _videoCtrl = null;
      _videoInitialized = false;
      _loadedUrl = null;
    }
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _videoCtrl?.setVolume(_isMuted ? 0.0 : 1.0);
  }

  void _onPageChanged(int index, List<BannerAdEntity> ads) {
    _videoCtrl?.pause();
    setState(() => _current = index);
    _loadVideoForIndex(index, ads);
  }

  @override
  void deactivate() {
    _videoCtrl?.pause(); // navigated away — stop sound immediately
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    // Home tab brought back into view: reload the video.
    if (!widget.visible) return;
    final ads = ref.read(bannerAdsProvider).valueOrNull ?? [];
    if (ads.isNotEmpty) _loadVideoForIndex(_current, ads);
  }

  @override
  void dispose() {
    _loadGen++; // invalidates any in-flight initialize()
    WidgetsBinding.instance.removeObserver(this);
    _pageCtrl.dispose();
    _videoCtrl?.dispose();
    super.dispose();
  }

  Future<void> _handleTap(BannerAdEntity ad) async {
    if (ad.title == 'Sub-Banner') {
      context.push('/subscribe');
      return;
    }
    if (ad.actionUrl != null) {
      final uri = Uri.tryParse(ad.actionUrl!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adsAsync = ref.watch(bannerAdsProvider);
    return adsAsync.when(
      loading: () => _buildSlider(ads: const [], loading: true),
      error: (_, __) => _buildSlider(ads: const []),
      data: (ads) {
        // _initialLoadRequested guards against scheduling on every rebuild.
        if (!_initialLoadRequested && widget.visible && ads.isNotEmpty) {
          _initialLoadRequested = true;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _loadVideoForIndex(0, ads),
          );
        }
        return _buildSlider(ads: ads);
      },
    );
  }

  Widget _buildSlider({
    required List<BannerAdEntity> ads,
    bool loading = false,
  }) {
    final count = ads.isEmpty ? 2 : ads.length;
    // Decode banner images at display size instead of full resolution.
    final bannerCacheWidth =
        ((MediaQuery.sizeOf(context).width - 32) *
                MediaQuery.devicePixelRatioOf(context))
            .round();
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: count,
            onPageChanged: (i) => _onPageChanged(i, ads),
            itemBuilder: (_, i) {
              final ad = ads.isEmpty ? null : ads[i];
              final isVideoSlide =
                  ad != null && (ad.videoUrl ?? '').isNotEmpty;
              final showVideo =
                  isVideoSlide && i == _current && _videoInitialized;
              final showVideoLoading =
                  isVideoSlide && i == _current && !_videoInitialized;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: ad == null ? null : () => _handleTap(ad),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: loading || showVideoLoading
                        ? _shimmer()
                        : showVideo
                            ? _BannerVideoItem(
                                controller: _videoCtrl!,
                                isMuted: _isMuted,
                                onToggleMute: _toggleMute,
                              )
                            : ad?.imageUrl != null
                                ? Image.network(
                                    ad!.imageUrl!,
                                    fit: BoxFit.cover,
                                    cacheWidth: bannerCacheWidth,
                                    loadingBuilder: (_, child, progress) =>
                                        progress == null ? child : _shimmer(),
                                    errorBuilder: (_, __, ___) =>
                                        _BannerPlaceholder(index: i),
                                  )
                                : _BannerPlaceholder(index: i),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _current == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _current == i
                    ? AppColors.dsPrimary
                    : AppColors.dsPrimary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _shimmer() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      );
}

// ─── Banner Video Item ────────────────────────────────────────────
// Stateless renderer — controller is owned by _BannerSliderState (one at a time).

class _BannerVideoItem extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const _BannerVideoItem({
    required this.controller,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.value.hasError) {
      return const Center(
        child: Icon(Icons.error_outline, color: Colors.white54, size: 48),
      );
    }
    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 22,
              ),
              onPressed: onToggleMute,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Banner Placeholder ───────────────────────────────────────────────────────
// Shown when no ads are available or when a banner image fails to load.

class _BannerPlaceholder extends StatelessWidget {
  final int index;
  const _BannerPlaceholder({required this.index});

  static const _colors = [
    [Color(0xFF2F6120), Color(0xFF82A346)],
    [Color(0xFFB35227), Color(0xFFDEB86A)],
  ];

  @override
  Widget build(BuildContext context) {
    final grad = _colors[index % _colors.length];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              index == 0 ? Icons.local_offer_rounded : Icons.card_giftcard_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  index == 0 ? 'Exclusive Deals' : 'Gift Vouchers',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  index == 0
                      ? 'Save big on your favourites'
                      : 'Perfect gifts for every occasion',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Grid ────────────────────────────────────────────────────────────

class _CategoryTabs extends ConsumerWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    // Grid is 2 columns with 16dp outer + 14dp inner padding; aspect 1.65.
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cardWidth = (MediaQuery.sizeOf(context).width - 32 - 14) / 2;
    final memCacheWidth = (cardWidth * dpr).round();
    final memCacheHeight = (cardWidth / 1.65 * dpr).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row: Title + View All link ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Categories',
                style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(selectedSellerCategoryProvider.notifier).state = null;
                  context.go('/sellers');
                },
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
        // ── Category cards grid ────────────────────────────────────────────
        if (categories.isEmpty)
          const SizedBox.shrink()
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.65,
              ),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final CategoryItem item = categories[i];
                final hasImage =
                    item.imageUrl != null && item.imageUrl!.isNotEmpty;
                final fallbackColor =
                    CategoryUtils.getFallbackColor(item);

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedSellerCategoryProvider.notifier).state =
                        item;
                    context.go('/sellers');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: fallbackColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // ── Background image ──────────────────────────
                          if (hasImage)
                            CachedNetworkImage(
                              imageUrl: item.imageUrl!,
                              fit: BoxFit.cover,
                              memCacheWidth: memCacheWidth,
                              memCacheHeight: memCacheHeight,
                              placeholder: (_, __) => Container(
                                color: fallbackColor,
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: fallbackColor,
                              ),
                            ),
                          // ── Gradient overlay for text readability ─────
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(
                                      alpha: hasImage ? 0.65 : 0.0),
                                ],
                                stops: const [0.3, 1.0],
                              ),
                            ),
                          ),
                          // ── Text content ──────────────────────────────
                          Positioned(
                            left: 14,
                            right: 14,
                            bottom: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.name,
                                  style: AppTextStyles.dsTitleLg.copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: hasImage
                                        ? Colors.white
                                        : const Color(0xFF1C1A18),
                                    height: 1.1,
                                    letterSpacing: -0.3,
                                    shadows: hasImage
                                        ? [
                                            Shadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.subtitle != null &&
                                    item.subtitle!.isNotEmpty) ...
[
                                  const SizedBox(height: 3),
                                  Text(
                                    item.subtitle!,
                                    style: AppTextStyles.dsLabelMd.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: hasImage
                                          ? Colors.white
                                              .withValues(alpha: 0.80)
                                          : const Color(0xFF1C1A18)
                                              .withValues(alpha: 0.65),
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                        duration: 350.ms,
                        delay: Duration(milliseconds: 55 * i))
                    .slideY(begin: 0.06, end: 0);
              },
            ),
          ),
      ],
    );
  }
}

