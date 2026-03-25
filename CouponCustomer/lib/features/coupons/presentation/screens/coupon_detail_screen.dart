// lib/features/coupons/presentation/screens/coupon_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/category_utils.dart';
import '../../../home/domain/entities/home_coupon_entity.dart';

class CouponDetailScreen extends StatelessWidget {
  final HomeCouponEntity coupon;

  const CouponDetailScreen({super.key, required this.coupon});

  Color get _accent => CategoryUtils.getBaseColor(coupon.category);

  IconData get _icon => CategoryUtils.getIcon(coupon.category);

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    final now = DateTime.now();
    final daysLeft = coupon.validUntil.difference(now).inDays;

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // ── Hero header ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
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
                      _accent.withOpacity(0.18),
                      _accent.withOpacity(0.04),
                      AppColors.dsSurface,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // Large discount badge
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _accent.withOpacity(0.3), width: 2.5),
                      ),
                      child: Center(
                        child: Text(
                          '${coupon.discountPercent}%',
                          style: AppTextStyles.dsDisplayLg.copyWith(
                            fontSize: 30,
                            color: _accent,
                          ),
                        ),
                      ),
                    ).animate().scale(
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0.6, 0.6)),
                    const SizedBox(height: 12),
                    Text(
                      '${coupon.discountPercent}% OFF',
                      style: AppTextStyles.dsDisplayLg.copyWith(fontSize: 26),
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 4),
                    Text(
                      coupon.sellerName,
                      style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.55)),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
            ),
          ),

          // ── Big ticket card ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TicketCard(
                    coupon: coupon,
                    accent: _accent,
                    icon: _icon,
                    fmt: fmt,
                    daysLeft: daysLeft,
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.06),

                  const SizedBox(height: 28),

                  // ── How to Redeem ─────────────────────────────────────────
                  _SectionHeader(title: 'How to Redeem', accent: _accent)
                      .animate()
                      .fadeIn(delay: 380.ms),
                  const SizedBox(height: 16),
                  _HowToRedeemCard(accent: _accent)
                      .animate()
                      .fadeIn(delay: 420.ms),

                  const SizedBox(height: 32),

                  // ── Terms & Conditions ────────────────────────────────────
                  if (coupon.description != null &&
                      coupon.description!.isNotEmpty) ...[
                    _SectionHeader(title: 'Terms & Conditions', accent: _accent)
                        .animate()
                        .fadeIn(delay: 460.ms),
                    const SizedBox(height: 16),
                    _TermsList(
                            description: coupon.description!, accent: _accent)
                        .animate()
                        .fadeIn(delay: 500.ms),
                  ],

                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Large ticket card ────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  final HomeCouponEntity coupon;
  final Color accent;
  final IconData icon;
  final DateFormat fmt;
  final int daysLeft;

  const _TicketCard({
    required this.coupon,
    required this.accent,
    required this.icon,
    required this.fmt,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.05),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seller row
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accent, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(coupon.sellerName,
                              style: AppTextStyles.dsTitleLg
                                  .copyWith(fontSize: 17),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(
                            '${coupon.category} • ${coupon.sellerArea}',
                            style: AppTextStyles.dsLabelMd.copyWith(
                                color: AppColors.dsOnSurface.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(coupon.couponType,
                          style: AppTextStyles.dsLabelMd.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Dashed divider
                Row(
                  children: List.generate(
                    26,
                    (_) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 1,
                        color: AppColors.dsSurfaceContainerLow,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Footer info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SmallInfo(
                        label: 'VALID TILL',
                        value: fmt.format(coupon.validUntil),
                        valueColor: daysLeft <= 7
                            ? AppColors.dsTertiaryPink
                            : AppColors.dsOnSurface),
                    if (coupon.minSpend != null)
                      _SmallInfo(
                          label: 'MIN SPEND', value: '₹${coupon.minSpend}'),
                    _SmallInfo(
                      label: 'USES LEFT',
                      value:
                          '${coupon.usesRemaining} / ${coupon.maxUsesPerBook}',
                      valueColor: AppColors.dsSecondaryMint,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Punch-outs (ticket look)
          Positioned(
            left: -14,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                    color: AppColors.dsSurface, shape: BoxShape.circle),
              ),
            ),
          ),
          Positioned(
            right: -14,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                    color: AppColors.dsSurface, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── New Sections ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color accent;

  const _SectionHeader({required this.title, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyles.dsTitleLg.copyWith(
            fontSize: 18,
            color: AppColors.dsOnSurface.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class _HowToRedeemCard extends StatelessWidget {
  final Color accent;
  const _HowToRedeemCard({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RedeemStep(number: 1, text: 'Visit the\nStore', accent: accent),
          _DashedLine(accent: accent),
          _RedeemStep(number: 2, text: 'Show Your QR\nCode', accent: accent),
          _DashedLine(accent: accent),
          _RedeemStep(number: 3, text: 'Get\nDiscount', accent: accent),
        ],
      ),
    );
  }
}

class _RedeemStep extends StatelessWidget {
  final int number;
  final String text;
  final Color accent;

  const _RedeemStep({
    required this.number,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppTextStyles.dsTitleLg.copyWith(
                color: AppColors.dsSurfaceContainerLowest,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.dsLabelMd.copyWith(
            color: AppColors.dsOnSurface.withOpacity(0.7),
            fontSize: 10,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  final Color accent;
  const _DashedLine({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28), // Align visually with circles
      child: Row(
        children: List.generate(
          4,
          (_) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: 1,
            color: accent.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

class _TermsList extends StatelessWidget {
  final String description;
  final Color accent;
  const _TermsList({required this.description, required this.accent});

  @override
  Widget build(BuildContext context) {
    // If the description uses actual newlines for bullet points
    final terms = description
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: terms
          .map((term) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        term,
                        style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.65),
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _SmallInfo extends StatelessWidget {
  final String label, value;
  final Color? valueColor;

  const _SmallInfo({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.dsLabelMd.copyWith(
                fontSize: 8, color: AppColors.dsOnSurface.withOpacity(0.4))),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.dsLabelMd.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.dsOnSurface,
            )),
      ],
    );
  }
}
