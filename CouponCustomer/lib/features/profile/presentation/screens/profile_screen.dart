import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/app_header.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: profileAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.dsPrimary)),
          error: (error, _) => Center(
              child: Text('Error: $error',
                  style: AppTextStyles.dsBodyMd
                      .copyWith(color: AppColors.dsTertiaryPink))),
          data: (user) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Header Profile Info ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.dsSurfaceContainerLow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dsOnSurface.withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: AppColors.dsPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name != null && user.name!.trim().isNotEmpty
                                  ? user.name!
                                  : 'Hey, there!',
                              style: AppTextStyles.dsDisplayLg
                                  .copyWith(fontSize: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '+91 ${user.phone}',
                              style: AppTextStyles.dsBodyMd.copyWith(
                                color: AppColors.dsOnSurface.withOpacity(0.6),
                              ),
                            ),
                            if (user.subscriptionStatus == 'ACTIVE') ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.dsSecondaryMint
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppColors.dsSecondaryMint,
                                        size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'PREMIUM MEMBER',
                                      style: AppTextStyles.dsLabelMd.copyWith(
                                        color: AppColors.dsSecondaryMint,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ── Menu List ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.dsSurfaceContainerLowest,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dsOnSurface.withOpacity(0.02),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _MenuTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Account Settings',
                          onTap: () => context.push('/account-settings'),
                          isFirst: true,
                        ),
                        _MenuTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          onTap: () => context.push('/support'),
                        ),
                        _MenuTile(
                          icon: Icons.info_outline_rounded,
                          title: 'About Us',
                          onTap: () => context.push('/about-us'),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Log Out Button ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        ref.invalidate(profileProvider);
                        ref.invalidate(userSettingsProvider);
                        if (context.mounted) context.go('/login');
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.dsTertiaryPink,
                        size: 18,
                      ),
                      label: Text(
                        'Log Out',
                        style: AppTextStyles.dsButton.copyWith(
                          color: AppColors.dsTertiaryPink,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        backgroundColor:
                            AppColors.dsTertiaryPink.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
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

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? 24 : 0),
        bottom: Radius.circular(isLast ? 24 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.dsPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.dsPrimary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.dsTitleLg.copyWith(fontSize: 16),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.dsOnSurface.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
