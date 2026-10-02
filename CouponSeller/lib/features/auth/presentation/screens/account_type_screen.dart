import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AccountTypeScreen extends StatelessWidget {
  final Map<String, dynamic> extra;

  const AccountTypeScreen({
    super.key,
    required this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Select Account Type',
          style: AppTextStyles.headlineSM.copyWith(color: AppColors.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'How do you want to join?',
                style: AppTextStyles.headlineMD,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Choose the profile that best describes you.',
                style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              _TypeCard(
                title: 'Business / Store',
                subtitle: 'I have a physical store, restaurant, or service business.',
                icon: Icons.storefront_outlined,
                onTap: () {
                  context.push('/registration', extra: extra);
                },
              ),
              
              const SizedBox(height: 24),
              
              _TypeCard(
                title: 'Influencer / Creator',
                subtitle: 'I want to offer promotion services on my social channels.',
                icon: Icons.campaign_outlined,
                onTap: () {
                  context.push('/influencer-registration', extra: extra);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 32),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLG),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
