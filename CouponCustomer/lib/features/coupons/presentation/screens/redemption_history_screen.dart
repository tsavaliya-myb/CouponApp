// lib/features/coupons/presentation/screens/redemption_history_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_header.dart';

class RedemptionHistoryScreen extends StatefulWidget {
  const RedemptionHistoryScreen({super.key});

  @override
  State<RedemptionHistoryScreen> createState() => _RedemptionHistoryScreenState();
}

class _RedemptionHistoryScreenState extends State<RedemptionHistoryScreen> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true, // Needed for floating authentic glass bottom nav
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              AppHeader(
                title: 'Redemption History',
                showSearchBar: false,
                titleStyle: AppTextStyles.dsTitleLg.copyWith(
                  color: AppColors.dsPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                leftWidget: Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.dsPrimary, size: 28),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Milestone Card ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.dsPrimary, AppColors.dsPrimary.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dsPrimary.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTHLY MILESTONE',
                            style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsSurfaceContainerLowest.withOpacity(0.7),
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹1250',
                            style: AppTextStyles.dsDisplayLg.copyWith(
                              color: AppColors.dsSurfaceContainerLowest,
                              fontSize: 48,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Saved this Month',
                            style: AppTextStyles.dsBodyMd.copyWith(
                              color: AppColors.dsSurfaceContainerLowest.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      // Decorative Sparkles
                      Positioned(
                        right: -10,
                        top: 10,
                        child: Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.15), size: 100),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Time Filter Tabs ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _buildFilterTab(0, 'This Week'),
                    const SizedBox(width: 12),
                    _buildFilterTab(1, 'This Month'),
                    const SizedBox(width: 12),
                    _buildFilterTab(2, 'All Time'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── History List ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const _HistoryListTile(
                      title: 'The Gourmet Studio',
                      savedAmt: '₹250 Saved',
                      pillText: '20% OFF',
                      coinsText: 'Used 10 Coins',
                      dateText: '24 OCT, 08:30 PM',
                      iconBgColor: AppColors.dsPrimaryContainer,
                      iconColor: AppColors.dsPrimary,
                      icon: Icons.restaurant_rounded,
                    ),
                    const SizedBox(height: 16),
                    _HistoryListTile(
                      title: 'Style Quotient',
                      savedAmt: '₹400 Saved',
                      pillText: 'FLAT ₹400',
                      coinsText: 'Used 25 Coins',
                      dateText: '22 OCT, 11:15 AM',
                      iconBgColor: AppColors.dsTertiaryPink.withOpacity(0.15),
                      iconColor: AppColors.dsTertiaryPink,
                      icon: Icons.content_cut_rounded,
                    ),
                    const SizedBox(height: 16),
                    // Zudio Surat (Ticket Style)
                    const _HistoryTicketTile(
                      title: 'Zudio Surat',
                      savedAmt: '₹600 Saved',
                      couponText: 'Buy 1 Get 1',
                      dateText: '20 OCT, 2023',
                      iconColor: AppColors.dsPrimary,
                      icon: Icons.shopping_bag_rounded,
                    ),
                    const SizedBox(height: 16),
                    _HistoryListTile(
                      title: 'Coffee Culture',
                      savedAmt: '₹150 Saved',
                      pillText: '1+1 BEVERAGE',
                      coinsText: 'Used 5 Coins',
                      dateText: '18 OCT, 05:45 PM',
                      iconBgColor: AppColors.dsTertiaryPink.withOpacity(0.15),
                      iconColor: AppColors.dsTertiaryPink,
                      icon: Icons.local_cafe_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ── Footer ──────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.dsPrimary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.history_rounded, color: AppColors.dsPrimary.withOpacity(0.6), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Showing redemptions from Oct 2023',
                style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6)),
              ),

              const SizedBox(height: 140), // Buffer for the glassmorphic bottom nav
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildFilterTab(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dsPrimary : AppColors.dsPrimary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.dsLabelMd.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.dsSurfaceContainerLowest : AppColors.dsOnSurface,
          ),
        ),
      ),
    );
  }
}


class _HistoryListTile extends StatelessWidget {
  final String title;
  final String savedAmt;
  final String pillText;
  final String coinsText;
  final String dateText;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;

  const _HistoryListTile({
    required this.title,
    required this.savedAmt,
    required this.pillText,
    required this.coinsText,
    required this.dateText,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.04), // Ambient shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(title, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18)),
                        ),
                        Text(
                          savedAmt,
                          style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsSecondaryMint, fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.dsTertiaryPink.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            pillText,
                            style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsTertiaryPink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('•', style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.4))),
                        const SizedBox(width: 8),
                        Text(
                          coinsText,
                          style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DashedDivider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_filled_rounded, size: 14, color: AppColors.dsOnSurface.withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Text(
                    dateText,
                    style: AppTextStyles.dsLabelMd.copyWith(
                      color: AppColors.dsOnSurface.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.dsPrimary.withOpacity(0.5), size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTicketTile extends StatelessWidget {
  final String title;
  final String savedAmt;
  final String couponText;
  final String dateText;
  final Color iconColor;
  final IconData icon;

  const _HistoryTicketTile({
    required this.title,
    required this.savedAmt,
    required this.couponText,
    required this.dateText,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(
                            savedAmt,
                            style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsSecondaryMint, fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _DashedDivider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('COUPON', style: AppTextStyles.dsLabelMd.copyWith(fontSize: 10, color: AppColors.dsOnSurface.withOpacity(0.6))),
                        const SizedBox(height: 2),
                        Text(couponText, style: AppTextStyles.dsLabelMd.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         Text('DATE', style: AppTextStyles.dsLabelMd.copyWith(fontSize: 10, color: AppColors.dsOnSurface.withOpacity(0.6))),
                         const SizedBox(height: 2),
                         Text(dateText, style: AppTextStyles.dsLabelMd.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Left Punch Out
          Positioned(
            left: -12,
            top: 24 + 56 + 20 - 12, // approx alignment with divider
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
            top: 24 + 56 + 20 - 12, // approx alignment with divider
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

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        30,
        (_) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 1,
            color: AppColors.dsSurfaceContainerLow,
          ),
        ),
      ),
    );
  }
}


