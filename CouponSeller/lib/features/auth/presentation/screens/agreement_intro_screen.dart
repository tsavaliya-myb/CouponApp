// lib/features/auth/presentation/screens/agreement_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class AgreementIntroScreen extends StatelessWidget {
  const AgreementIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Coupon360 Seller',
          style: AppTextStyles.headlineSM.copyWith(
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl,
                  vertical: AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Icon
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.05),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Sign Your\nSeller Agreement',
                      style: AppTextStyles.headlineLG.copyWith(
                        color: AppColors.primary,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Before you can start receiving redemptions, you need to digitally sign our seller agreement.',
                      style: AppTextStyles.bodyMD.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // What to expect section
                    Text(
                      'WHAT TO EXPECT',
                      style: AppTextStyles.labelSM.copyWith(
                        color: AppColors.primary.withOpacity(0.6),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildStep(
                      number: '01',
                      title: 'Aadhaar eSign',
                      subtitle:
                          'Verify your identity securely using Aadhaar-based electronic signature.',
                      icon: Icons.fingerprint,
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      number: '02',
                      title: 'Virtual Sign',
                      subtitle:
                          'Draw or type your virtual signature to confirm your agreement.',
                      icon: Icons.draw_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      number: '03',
                      title: 'Agreement Confirmed',
                      subtitle:
                          'A signed copy of the agreement will be sent to your registered email.',
                      icon: Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 32),

                    // What you need section
                    Text(
                      'WHAT YOU\'LL NEED',
                      style: AppTextStyles.labelSM.copyWith(
                        color: AppColors.primary.withOpacity(0.6),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNeedItem(
                      icon: Icons.credit_card_outlined,
                      text: 'Your Aadhaar-linked mobile number',
                    ),
                    const SizedBox(height: 10),
                    _buildNeedItem(
                      icon: Icons.wifi_outlined,
                      text: 'Stable internet connection',
                    ),
                    const SizedBox(height: 10),
                    _buildNeedItem(
                      icon: Icons.timer_outlined,
                      text: 'Approximately 3–5 minutes',
                    ),
                    const SizedBox(height: 32),

                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.12),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'The signing process is powered by Leegality, a government-approved digital signature platform.',
                              style: AppTextStyles.bodySM.copyWith(
                                color: AppColors.primary.withOpacity(0.7),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withOpacity(0.04),
                    offset: const Offset(0, -10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/agreement-webview'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'Start Signing',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      number,
                      style: AppTextStyles.labelSM.copyWith(
                        color: AppColors.primary.withOpacity(0.5),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: AppTextStyles.bodyMD.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySM.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
