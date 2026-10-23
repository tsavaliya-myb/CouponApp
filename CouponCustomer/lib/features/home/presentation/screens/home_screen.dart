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
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Prefetch both datasets in the background as soon as home screen mounts.
    ref.watch(allCouponsProvider);
    ref.watch(allSellersProvider);

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
                  child: const Column(
                    children: [
                      SizedBox(height: 20),
                      _HomeHeader(),
                      SizedBox(height: 10),
                      _BannerSlider(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            // ── Category Tabs ─────────────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            const SliverToBoxAdapter(child: _CategoryTabs()),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () => context.push('/influencers'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.dsPrimary, Color(0xFFF39C12)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover Influencers',
                              style: AppTextStyles.heading2.copyWith(color: Colors.white),
                            ),
                            Text(
                              'Book promotional services',
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
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
  const _BannerSlider();

  @override
  ConsumerState<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends ConsumerState<_BannerSlider>
    with WidgetsBindingObserver {
  final _controller = PageController();
  int _current = 0;
  Timer? _timer;
  bool _autoScrollStarted = false;

  // Keys to directly call pause/resume on the active video item.
  final Map<int, GlobalKey<_BannerVideoItemState>> _videoKeys = {};
  GlobalKey<_BannerVideoItemState>? get _currentVideoKey => _videoKeys[_current];

  void _startAutoScroll(int count) {
    if (_autoScrollStarted) return;
    _autoScrollStarted = true;
    _timer?.cancel();
    if (count <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % count;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _currentVideoKey?.currentState?.pauseVideo();
    } else {
      _currentVideoKey?.currentState?.resumeVideo();
    }
  }

  void _onPageChanged(int index) {
    // Pause outgoing slide, resume incoming slide.
    _videoKeys[_current]?.currentState?.pauseVideo();
    setState(() => _current = index);
    _videoKeys[index]?.currentState?.resumeVideo();
  }

  @override
  void deactivate() {
    // Called when navigating away - stop sound immediately.
    _currentVideoKey?.currentState?.pauseVideo();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap(BannerAdEntity ad) async {
    if (ad.title == 'Sub-Banner') {
      context.push('/subscribe');
      return;
    }

    // Fire click tracking (fire-and-forget — no auth needed)
    // We call directly via the API URL; tracking failures are silent.
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
        return _buildSlider(ads: ads);
      },
    );
  }

  Widget _buildSlider({
    required List<BannerAdEntity> ads,
    bool loading = false,
  }) {
    final count = ads.isEmpty ? 2 : ads.length; // 2 placeholders when empty

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: _onPageChanged,
            itemBuilder: (_, i) {
              final ad = ads.isEmpty ? null : ads[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: ad == null ? null : () => _handleTap(ad),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: loading
                        ? _shimmer()
                        : ad != null &&
                            ad.videoUrl != null &&
                            ad.videoUrl!.isNotEmpty
                            ? _BannerVideoItem(
                                key: _videoKeys.putIfAbsent(
                                  i,
                                  () => GlobalKey<_BannerVideoItemState>(),
                                ),
                                ad: ad,
                                isActive: i == _current,
                              )
                            : ad?.imageUrl != null
                                ? Image.network(
                                    ad!.imageUrl!,
                                    fit: BoxFit.cover,
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

// ─── Banner Video Item ────────────────────────────────────────────────────────
// Plays banner videos with autoplay, looping, and a mute toggle at bottom-right.

class _BannerVideoItem extends StatefulWidget {
  final BannerAdEntity ad;
  final bool isActive;
  const _BannerVideoItem({super.key, required this.ad, required this.isActive});

  @override
  State<_BannerVideoItem> createState() => _BannerVideoItemState();
}

class _BannerVideoItemState extends State<_BannerVideoItem>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _isMuted = true;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true; // keeps state alive in PageView

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoUrl = widget.ad.videoUrl;
    if (videoUrl == null || videoUrl.isEmpty) return;
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    await controller.initialize();
    if (!mounted) {
      controller.dispose(); // safe cleanup if unmounted during async gap
      return;
    }
    controller.setLooping(true); // must be set BEFORE play()
    controller.setVolume(0.0);   // start muted
    setState(() {
      _controller = controller;
      _isInitialized = true;
    });
    if (widget.isActive) controller.play(); // only play the visible slide
  }

  @override
  void didUpdateWidget(covariant _BannerVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ad.videoUrl != widget.ad.videoUrl) {
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _initializeVideo();
    } else if (oldWidget.isActive != widget.isActive) {
      // Pause off-screen; resume when scrolled back – fixes buffer exhaustion
      widget.isActive ? _controller?.play() : _controller?.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void pauseVideo() => _controller?.pause();
  void resumeVideo() => _controller?.play();

  Future<void> _toggleMute() async {
    if (_controller == null) return;
    setState(() => _isMuted = !_isMuted);
    await _controller!.setVolume(_isMuted ? 0.0 : 1.0);
  }

  Widget _localShimmer() => Container(
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    if (_controller == null || !_isInitialized) {
      return _localShimmer();
    }
    if (_controller!.value.hasError) {
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
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        // Mute / unmute toggle at bottom-right
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
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 22,
              ),
              onPressed: _toggleMute,
              tooltip: _isMuted ? 'Unmute' : 'Mute',
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

