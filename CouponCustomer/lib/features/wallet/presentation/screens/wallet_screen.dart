// lib/features/wallet/presentation/screens/wallet_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // ── Hero Balance Card ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.dsPrimary, AppColors.dsPrimaryContainer],
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
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dsSurfaceContainerLowest.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.monetization_on_outlined, color: AppColors.dsSurfaceContainerLowest, size: 28),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'AVAILABLE BALANCE',
                        style: AppTextStyles.dsLabelMd.copyWith(
                          color: AppColors.dsSurfaceContainerLowest.withOpacity(0.8),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '85',
                            style: AppTextStyles.dsDisplayLg.copyWith(
                              color: AppColors.dsSurfaceContainerLowest,
                              fontSize: 64,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Coins',
                            style: AppTextStyles.dsTitleLg.copyWith(
                              color: AppColors.dsSurfaceContainerLowest.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.dsSurfaceContainerLowest.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.dsSurfaceContainerLowest.withOpacity(0.9), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              '1 Coin = ₹1',
                              style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsSurfaceContainerLowest),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Lifetime Statistics Row ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.trending_up_rounded,
                        iconColor: AppColors.dsSecondaryMint,
                        label: 'LIFETIME EARNED',
                        value: '150',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.shopping_bag_rounded,
                        iconColor: AppColors.dsTertiaryPink,
                        label: 'LIFETIME\nREDEEMED',
                        value: '65',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Recent Activity ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Activity', style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
                    Row(
                      children: [
                        Text('View Ledger', style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsPrimary, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.dsPrimary, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const _TransactionEarnedTile(
                      title: 'Daily Check-in Reward',
                      amount: '+50',
                      subtext: 'Earned • App Reward',
                      date: 'Oct 24, 2023 • 09:15 AM',
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: AppColors.dsSecondaryMint,
                    ),
                    const SizedBox(height: 16),
                    const _TransactionUsedTicket(
                      title: 'Starbucks Surat',
                      amount: '-15',
                      subtext: 'USED • MERCHANT PAYMENT',
                      date: 'Oct 23, 2023 • 04:30 PM',
                      icon: Icons.storefront_rounded,
                    ),
                    const SizedBox(height: 16),
                    const _TransactionEarnedTile(
                      title: 'Referral Bonus',
                      amount: '+25',
                      subtext: 'Earned • Invite Friend',
                      date: 'Oct 21, 2023 • 11:45 AM',
                      icon: Icons.card_giftcard_rounded,
                      iconColor: AppColors.dsSecondaryMint,
                    ),
                    const SizedBox(height: 16),
                    const _TransactionUsedTicket(
                      title: 'Zudio Fashion',
                      amount: '-50',
                      subtext: 'USED • DISCOUNT APPLIED',
                      date: 'Oct 19, 2023 • 08:20 PM',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Promo Card (Need more coins?) ───────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomPaint(
                  painter: _DashedBorderPainter(color: AppColors.dsPrimary.withOpacity(0.2), radius: 32),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.dsSurfaceContainerLow.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      children: [
                        Text('Need more coins?', style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(
                          'Complete daily challenges or invite friends to grow your balance faster!',
                          style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.dsPrimaryContainer, AppColors.dsPrimary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text('Invite Friends', style: AppTextStyles.dsButton.copyWith(fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 140), // Buffer for the glassmorphic bottom nav
            ],
          ),
        ),
      ),
    );
  }
}



class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 16),
          Text(
            label,
            style: AppTextStyles.dsLabelMd.copyWith(
              color: AppColors.dsOnSurface.withOpacity(0.7),
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTextStyles.dsDisplayLg.copyWith(fontSize: 24)),
              const SizedBox(width: 4),
              Text('Coins', style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionEarnedTile extends StatelessWidget {
  final String title;
  final String amount;
  final String subtext;
  final String date;
  final IconData icon;
  final Color iconColor;

  const _TransactionEarnedTile({
    required this.title,
    required this.amount,
    required this.subtext,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 15)),
                    Text(amount, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 16, color: iconColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(subtext, style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6))),
                    ),
                    const SizedBox(width: 16),
                    Text(date, style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.4), fontSize: 9)),
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

class _TransactionUsedTicket extends StatelessWidget {
  final String title;
  final String amount;
  final String subtext;
  final String date;
  final IconData icon;

  const _TransactionUsedTicket({
    required this.title,
    required this.amount,
    required this.subtext,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left Purple Border Strip
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: const BoxDecoration(
                color: AppColors.dsPrimary,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 4), // offset for the strip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dsPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.dsPrimary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 15)),
                          Text(amount, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 16, color: AppColors.dsOnSurface.withOpacity(0.8))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(subtext, style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6))),
                          ),
                          const SizedBox(width: 8),
                          Text(date, style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.4), fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),

          // Left Punch Out
          Positioned(
            left: -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.dsSurface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Right Punch Out
          Positioned(
            right: -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.dsSurface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    Path dashPath = Path();
    double dashWidth = 8.0;
    double dashSpace = 6.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


