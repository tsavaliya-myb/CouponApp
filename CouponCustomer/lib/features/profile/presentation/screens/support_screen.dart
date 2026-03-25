import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
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
                      AppColors.dsPrimary.withOpacity(0.18),
                      AppColors.dsPrimary.withOpacity(0.04),
                      AppColors.dsSurface,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.dsPrimary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.dsPrimary.withOpacity(0.3), width: 2.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.support_agent_rounded,
                            color: AppColors.dsPrimary, size: 28),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Help & Support',
                      style: AppTextStyles.dsDisplayLg.copyWith(fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Us', style: AppTextStyles.dsTitleLg),
                  const SizedBox(height: 16),
                  Text(
                    'If you have any issues or questions about your subscription, coupon redemptions, or account, please contact our support team.',
                    style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 24),
                  _ContactTile(icon: Icons.email_outlined, title: 'support@couponapp.in'),
                  const SizedBox(height: 16),
                  _ContactTile(icon: Icons.phone_outlined, title: '+91 1800 123 4567'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ContactTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
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
          Icon(icon, color: AppColors.dsPrimary),
          const SizedBox(width: 16),
          Text(title, style: AppTextStyles.dsBodyMd.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
