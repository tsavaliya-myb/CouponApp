// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/home_provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/models/category_item.dart';
import '../../../../core/utils/category_utils.dart';
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
      extendBodyBehindAppBar: true,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
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
                      SizedBox(
                        height: MediaQuery.of(ctx).padding.top +
                            kToolbarHeight +
                            50,
                      ),
                      const _HomeHeader(),
                      const SizedBox(height: 10),
                      const _BannerSlider(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            // ── Category Tabs ─────────────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            const SliverToBoxAdapter(child: _CategoryTabs()),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
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

// ─── Banner Slider ────────────────────────────────────────────────────────────

class _BannerSlider extends StatefulWidget {
  const _BannerSlider();

  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  final _controller = PageController();
  int _current = 0;

  // Replace these with your actual asset paths e.g. 'assets/images/banner1.png'
  static const _banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  _banners[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _BannerPlaceholder(index: i),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
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
}

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
              index == 0
                  ? Icons.local_offer_rounded
                  : Icons.card_giftcard_rounded,
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

  static const _cardColor = {
    'all': Color(0xFFDEB86A),
    'food': Color(0xFFB35227),
    'cafe': Color(0xFF2F6120),
    'salon': Color(0xFF70586F),
    'spa': Color(0xFF179156),
    'theater': Color(0xFF82A346),
    'default': Color(0xFFB1BAAE),
  };

  static const _subtitles = {
    'all': 'Browse everything',
    'food': 'Restaurants & more',
    'cafe': 'Coffee & drinks',
    'salon': 'Hair & beauty',
    'spa': 'Relax & unwind',
    'theater': 'Movies & shows',
    'default': 'Explore deals',
  };

  Color _colorFor(String slug) => _cardColor[slug] ?? _cardColor['default']!;
  String _subtitleFor(String slug) =>
      _subtitles[slug] ?? _subtitles['default']!;

  // Dark text for light cards, white for dark cards
  Color _textColorFor(Color card) =>
      card.computeLuminance() > 0.3 ? const Color(0xFF1C1A18) : Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];
    final itemCount = categories.length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Categories',
            style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20),
          ),
        ),
        const SizedBox(height: 16),
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
            itemCount: itemCount,
            itemBuilder: (_, i) {
              final isAll = i == 0;
              final CategoryItem? item = isAll ? null : categories[i - 1];
              final isSelected = selected == item;
              final label = isAll ? 'All' : item!.name;
              final slug = isAll ? 'all' : item!.slug;
              final icon =
                  isAll ? Icons.grid_view_rounded : CategoryUtils.getIcon(slug);
              final cardColor = _colorFor(slug);
              final textColor = _textColorFor(cardColor);
              final subtitle = _subtitleFor(slug);
              final isLight = textColor != Colors.white;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedSellerCategoryProvider.notifier).state = item;
                  context.go('/sellers');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardColor.withValues(
                            alpha: isSelected ? 0.55 : 0.28),
                        blurRadius: isSelected ? 22 : 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Per-category decorations
                      ..._decorationsFor(slug, isLight),
                      // Ghost icon — larger, more visible
                      Positioned(
                        right: -10,
                        top: -6,
                        bottom: -6,
                        child: Center(
                          child: Icon(
                            icon,
                            size: 90,
                            color: isLight
                                ? Colors.black.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                      ),
                      // Text content — left aligned, big
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 80, top: 16, bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              label,
                              style: AppTextStyles.dsTitleLg.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                height: 1.1,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: AppTextStyles.dsLabelMd.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: textColor.withValues(alpha: 0.65),
                                letterSpacing: 0.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                      duration: 350.ms, delay: Duration(milliseconds: 55 * i))
                  .slideY(begin: 0.06, end: 0);
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _decorationsFor(String slug, bool isLight) {
    final c = isLight
        ? Colors.black.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.18);

    switch (slug) {
      // Circles — All
      case 'all':
        return [
          _circle(c, 18, top: 8, left: 12),
          _circle(c, 10, top: 28, left: 36),
          _circle(c, 14, top: 4, left: 55),
          _circle(c, 8, top: 20, left: 76),
        ];
      // Triangles — Food
      case 'food':
        return [
          _triangle(c, 12, top: 6, left: 10),
          _triangle(c, 8, top: 22, left: 30),
          _triangle(c, 14, top: 4, left: 52),
          _triangle(c, 10, top: 18, left: 72),
        ];
      // Dots grid — Cafe
      case 'cafe':
        return [
          for (var r = 0; r < 3; r++)
            for (var col = 0; col < 4; col++)
              _circle(c, 5, top: 8.0 + r * 12, left: 8.0 + col * 14),
        ];
      // Horizontal lines — Salon
      case 'salon':
        return [
          _line(c, w: 28, h: 3, top: 10, left: 8),
          _line(c, w: 18, h: 3, top: 20, left: 16),
          _line(c, w: 24, h: 3, top: 30, left: 10),
        ];
      // Plus / cross shapes — Spa
      case 'spa':
        return [
          _plus(c, 12, top: 6, left: 10),
          _plus(c, 8, top: 24, left: 34),
          _plus(c, 14, top: 4, left: 56),
          _plus(c, 10, top: 20, left: 78),
        ];
      // Stars (5-pt via rotated squares) — Theater
      case 'theater':
        return [
          _star(c, 14, top: 6, left: 10),
          _star(c, 10, top: 22, left: 32),
          _star(c, 12, top: 4, left: 54),
          _star(c, 8, top: 20, left: 74),
        ];
      // Diamonds — default
      default:
        return [
          _diamond(c, 10, top: 8, left: 10),
          _diamond(c, 7, top: 22, left: 30),
          _diamond(c, 12, top: 4, left: 52),
          _diamond(c, 8, top: 20, left: 72),
        ];
    }
  }

  Widget _circle(Color c, double size,
          {required double top, required double left}) =>
      Positioned(
        top: top,
        left: left,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
      );

  Widget _diamond(Color c, double size,
          {required double top, required double left}) =>
      Positioned(
        top: top,
        left: left,
        child: Transform.rotate(
          angle: 0.785,
          child: Container(
            width: size,
            height: size,
            decoration:
                BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
          ),
        ),
      );

  Widget _triangle(Color c, double size,
          {required double top, required double left}) =>
      Positioned(
        top: top,
        left: left,
        child: Transform.rotate(
          angle: 0.0,
          child: CustomPaint(
            size: Size(size, size),
            painter: _TrianglePainter(c),
          ),
        ),
      );

  Widget _line(Color c,
          {required double w,
          required double h,
          required double top,
          required double left}) =>
      Positioned(
        top: top,
        left: left,
        child: Container(
          width: w,
          height: h,
          decoration:
              BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
        ),
      );

  Widget _plus(Color c, double size,
      {required double top, required double left}) {
    final arm = size / 3;
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(children: [
          Positioned(
              left: arm,
              top: 0,
              child: Container(
                  width: arm,
                  height: size,
                  decoration: BoxDecoration(
                      color: c, borderRadius: BorderRadius.circular(2)))),
          Positioned(
              left: 0,
              top: arm,
              child: Container(
                  width: size,
                  height: arm,
                  decoration: BoxDecoration(
                      color: c, borderRadius: BorderRadius.circular(2)))),
        ]),
      ),
    );
  }

  Widget _star(Color c, double size,
          {required double top, required double left}) =>
      Positioned(
        top: top,
        left: left,
        child: Stack(children: [
          Transform.rotate(
              angle: 0,
              child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      color: c, borderRadius: BorderRadius.circular(2)))),
          Transform.rotate(
              angle: 0.785,
              child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      color: c, borderRadius: BorderRadius.circular(2)))),
        ]),
      );
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

