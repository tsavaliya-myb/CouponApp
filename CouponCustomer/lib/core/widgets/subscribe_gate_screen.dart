// lib/core/widgets/subscribe_gate_screen.dart
//
// Full-screen lock wall shown on non-home tabs when user is not subscribed.
// No API calls are made when this is visible.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SubscribeGateScreen extends StatelessWidget {
  /// The tab label shown in the gate (e.g. "My Coupons", "Wallet", "Sellers")
  final String featureName;

  const SubscribeGateScreen({
    super.key,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Blurred card preview (aesthetic blur behind the lock)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blurred background placeholder cards
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.dsPrimary.withOpacity(0.08),
                                AppColors.dsPrimaryContainer.withOpacity(0.04),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.dsPrimary.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 6),
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.dsOnSurface.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Lock icon overlay
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.dsSurfaceContainerLowest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dsPrimary.withOpacity(0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.dsPrimary,
                        size: 30,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05),

                const SizedBox(height: 36),

                // Title
                Text(
                  'Unlock & Save Big!',
                  style: AppTextStyles.dsDisplayLg.copyWith(
                    fontSize: 24,
                    color: AppColors.dsOnSurface,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 350.ms, delay: 100.ms),
                const SizedBox(height: 12),

                // Body text
                Text(
                  'Join Coupon Code and get instant access to 100+ handpicked coupons, and the best deals from top-rated sellers near you — all in one place!',
                  style: AppTextStyles.dsBodyMd.copyWith(
                    color: AppColors.dsOnSurface.withOpacity(0.6),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 350.ms, delay: 150.ms),

                const SizedBox(height: 12),

                // CTA
                GestureDetector(
                  onTap: () => context.push('/subscribe'),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.dsPrimary,
                          AppColors.dsPrimaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dsPrimary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Subscribe Now',
                          style: AppTextStyles.dsButton.copyWith(fontSize: 17),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 350.ms, delay: 250.ms)
                    .slideY(begin: 0.15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
