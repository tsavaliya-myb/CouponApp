// lib/core/widgets/subscribe_bottom_sheet.dart
//
// Vertical popup shown when a non-subscriber taps a coupon or seller.
// Has a CTA that navigates to the /subscribe route.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Shows the subscribe bottom sheet modal.
/// Call this instead of navigating directly when a non-subscriber taps content.
void showSubscribeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _SubscribeBottomSheetContent(),
  );
}

class _SubscribeBottomSheetContent extends StatelessWidget {
  const _SubscribeBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.dsSurfaceContainerLowest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            border: Border.all(
              color: AppColors.dsPrimary.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.dsOnSurface.withOpacity(0.12),
                blurRadius: 48,
                offset: const Offset(0, -16),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.dsOnSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Lock Icon with gradient bg
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.dsPrimary.withOpacity(0.15),
                          AppColors.dsPrimaryContainer.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: AppColors.dsPrimary,
                      size: 36,
                    ),
                  ).animate().scale(
                      begin: const Offset(0.7, 0.7),
                      duration: 350.ms,
                      curve: Curves.elasticOut),
                  const SizedBox(height: 24),

                  // Headline
                  Text(
                    'Subscribe to Unlock',
                    style: AppTextStyles.dsDisplayLg.copyWith(
                      fontSize: 26,
                      color: AppColors.dsOnSurface,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                  const SizedBox(height: 12),

                  // Sub-text
                  Text(
                    'Get access to 100+ exclusive coupons and save ₹5000+ with a single subscription.',
                    style: AppTextStyles.dsBodyMd.copyWith(
                      color: AppColors.dsOnSurface.withOpacity(0.6),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
                  const SizedBox(height: 8),

                  // CTA Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/subscribe');
                    },
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
                            style:
                                AppTextStyles.dsButton.copyWith(fontSize: 17),
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
                      .fadeIn(duration: 300.ms, delay: 250.ms)
                      .slideY(begin: 0.2),

                  const SizedBox(height: 16),

                  // Cancel
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Maybe Later',
                      style: AppTextStyles.dsBodyMd.copyWith(
                        color: AppColors.dsOnSurface.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
