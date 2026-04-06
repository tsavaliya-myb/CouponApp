// lib/features/subscription/presentation/screens/purchase_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_header.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../features/payment/presentation/payment_controller.dart';

class PurchaseScreen extends ConsumerStatefulWidget {
  const PurchaseScreen({super.key});

  @override
  ConsumerState<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(userSettingsProvider);
    final userAsync = ref.watch(profileProvider);
    final paymentState = ref.watch(paymentControllerProvider);

    ref.listen<AsyncValue<void>>(
      paymentControllerProvider,
      (_, next) {
        next.whenOrNull(
          error: (err, stack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(err.toString()),
                backgroundColor: Colors.red,
              ),
            );
          },
          data: (_) {
            context.go('/subscription-success');
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true, // Needed for floating authentic glass bottom nav
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (settings) => SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              AppHeader(
                title: 'Coupon Code',
                showSearchBar: false,
                titleStyle: AppTextStyles.dsTitleLg.copyWith(
                  color: AppColors.dsOnSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 32),

              // ── Headline ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.dsDisplayLg.copyWith(
                            color: AppColors.dsOnSurface, height: 1.1),
                        children: [
                          const TextSpan(text: 'Your '),
                          TextSpan(
                            text: 'Savings\n',
                            style: TextStyle(
                              color: AppColors.dsPrimary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const TextSpan(text: 'Starts Here'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Unlock the city's best kept secrets and save big on your favorite local spots.",
                      style: AppTextStyles.dsBodyMd.copyWith(
                        color: AppColors.dsOnSurface.withOpacity(0.6),
                        height: 1.6,
                        fontFamily: 'Be Vietnam Pro',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Main Pricing Card ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.dsSurfaceContainerLowest,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dsOnSurface.withOpacity(0.04),
                        blurRadius: 32,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Limited Edition Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.dsPrimary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'LIMITED EDITION ACCESS',
                          style: AppTextStyles.dsLabelMd.copyWith(
                            color: AppColors.dsPrimary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Price
                      Text(
                        '₹${settings.subscriptionPrice}',
                        style: AppTextStyles.dsDisplayLg.copyWith(
                          fontSize: 64,
                          height: 1.0,
                          color: AppColors.dsOnSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'per season',
                        style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.6),
                          fontFamily: 'Be Vietnam Pro',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Validity Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.dsPrimary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                color: AppColors.dsPrimary, size: 14),
                            const SizedBox(width: 8),
                            Text(
                              'VALID FOR ${settings.bookValidityDays} DAYS',
                              style: AppTextStyles.dsLabelMd.copyWith(
                                color: AppColors.dsOnSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _FeatureBox(
                              icon: Icons.confirmation_number_rounded,
                              iconBg: AppColors.dsPrimary.withOpacity(0.1),
                              iconColor: AppColors.dsPrimary,
                              title: '${settings.totalActiveCoupons}',
                              subtitle: 'COUPONS',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _FeatureBox(
                              icon: Icons.payments_rounded,
                              iconBg:
                                  AppColors.dsSecondaryMint.withOpacity(0.15),
                              iconColor: AppColors.dsSecondaryMint,
                              title: '₹5000+',
                              subtitle: 'SAVINGS',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Categories Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _CategoryIcon(
                              icon: Icons.restaurant_rounded, label: 'FOOD'),
                          _CategoryIcon(
                              icon: Icons.content_cut_rounded, label: 'SALON'),
                          _CategoryIcon(
                              icon: Icons.shopping_bag_rounded,
                              label: 'RETAIL'),
                          _CategoryIcon(
                              icon: Icons.local_activity_rounded, label: 'FUN'),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Welcome Gift Banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.dsSurfaceContainerLowest,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: AppColors.dsPrimary.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dsPrimary.withOpacity(0.03),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.dsSurfaceContainerLowest,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.dsOnSurface.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.stars_rounded,
                                  color: AppColors.dsPrimary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Save More Per Visit',
                                      style: AppTextStyles.dsTitleLg
                                          .copyWith(fontSize: 15)),
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.dsLabelMd.copyWith(
                                        color: AppColors.dsOnSurface
                                            .withOpacity(0.6),
                                        fontSize: 10,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Use up to '),
                                        TextSpan(
                                          text: '${settings.maxCoinsPerTransaction} Coins',
                                          style: TextStyle(
                                              color: AppColors.dsPrimary,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const TextSpan(
                                            text: ' on every transaction.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Activate Button
                      GestureDetector(
                        onTap: paymentState.isLoading ? null : () {
                          if (settingsAsync.value == null || userAsync.value == null) return;
                          ref.read(paymentControllerProvider.notifier).startPaymentFlow(
                            contact: userAsync.value!.phone,
                            email: userAsync.value!.email ?? 'user@couponapp.in',
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 64, // Large prominent button
                          decoration: BoxDecoration(
                            color: paymentState.isLoading ? AppColors.dsOnSurface.withOpacity(0.5) : AppColors.dsOnSurface, // Very dark purple/black color
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.dsOnSurface.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (paymentState.isLoading)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              else ...[
                                Text(
                                  'Activate Now',
                                  style: AppTextStyles.dsButton.copyWith(fontSize: 18),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Trust Badges
                      Text(
                        'SECURE PAYMENT VIA RAZORPAY',
                        style: AppTextStyles.dsLabelMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.4),
                          letterSpacing: 1.5,
                          fontSize: 9,
                        ),
                      ),
                      // Placeholders for Razorpay/PCI logos as indicated in mockup
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 24,
                              height: 16,
                              color: AppColors.dsOnSurface.withOpacity(0.1)),
                          const SizedBox(width: 8),
                          Container(
                              width: 24,
                              height: 16,
                              color: AppColors.dsOnSurface.withOpacity(0.1)),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                  height: 140), // Buffer for the glassmorphic bottom nav
            ],
          ),
        ),
      ),
      ),
    );
  }
}
class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureBox({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.dsOnSurface.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.dsTitleLg.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: AppTextStyles.dsLabelMd
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.5))),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.dsOnSurface.withOpacity(0.5), size: 24),
        const SizedBox(height: 8),
        Text(label,
            style: AppTextStyles.dsLabelMd.copyWith(
                color: AppColors.dsOnSurface.withOpacity(0.5), fontSize: 9)),
      ],
    );
  }
}
