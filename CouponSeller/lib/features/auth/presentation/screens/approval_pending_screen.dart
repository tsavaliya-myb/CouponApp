import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ApprovalPendingScreen extends StatelessWidget {
  final String status;

  const ApprovalPendingScreen({
    super.key,
    this.status = 'PENDING',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Icon or Illustration
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                'Application Review',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLG.copyWith(
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Subtext
              Text(
                'Your business profile is currently being reviewed by our team. This process usually takes 24 to 48 hours.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMD.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Subtle Status indicator
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: status.toUpperCase() == 'PENDING' 
                              ? Colors.amber.shade400 
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${status.toUpperCase()}',
                        style: AppTextStyles.labelSM.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Support Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Need help?',
                      style: AppTextStyles.labelSM.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.support_agent_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'support@couponcode.com',
                          style: AppTextStyles.bodyMD.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+91 1234567890',
                          style: AppTextStyles.bodyMD.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Clear auth tokens from secure storage when logout usecase is available
                    context.go('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
