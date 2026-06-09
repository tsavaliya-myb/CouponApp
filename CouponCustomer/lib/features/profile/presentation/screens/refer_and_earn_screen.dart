import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/error_state.dart';
import '../providers/referral_provider.dart';

class ReferAndEarnScreen extends ConsumerWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(referralStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Refer & Earn',
              leftWidget: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
              showSearchBar: false,
              showProfileIcon: false,
              showDefaultLocation: false,
            ),
            Expanded(
              child: statsState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, _) => ErrorState(
                  message: error.toString(),
                  onRetry: () => ref.read(referralStatsProvider.notifier).refresh(),
                ),
                data: (stats) => SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Image / Graphic
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryLight, AppColors.primaryAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.card_giftcard_rounded,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title & Subtitle
                      Text(
                        'Invite your friends\n& earn rewards!',
                        style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Share your code with friends. When they subscribe, both of you get 5 coins! You can refer up to ${stats.maxLimit} friends.',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Referral Code Box
                      if (stats.referralCode != null && stats.referralCode!.isNotEmpty) ...[
                        Text(
                          'Your Referral Code',
                          style: AppTextStyles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  stats.referralCode!,
                                  style: AppTextStyles.heading1.copyWith(
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy_rounded, color: AppColors.primary),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: stats.referralCode!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Referral code copied!')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Share Button
                        ElevatedButton.icon(
                          onPressed: () {
                            Share.share(
                              'Use my referral code ${stats.referralCode} to get rewards when you join the app!',
                            );
                          },
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('Share Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ] else ...[
                        const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Generating your unique code...',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Stats Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Referral Stats',
                              style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatBox(
                                    icon: Icons.people_outline_rounded,
                                    title: 'Friends Joined',
                                    value: '${stats.successfulReferrals} / ${stats.maxLimit}',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatBox(
                                    icon: Icons.monetization_on_outlined,
                                    title: 'Coins Earned',
                                    value: '${stats.totalEarnedCoins}',
                                    iconColor: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _StatBox({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
