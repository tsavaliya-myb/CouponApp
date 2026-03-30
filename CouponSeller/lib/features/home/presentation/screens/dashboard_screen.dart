// lib/features/home/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/dashboard_provider.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: dashboardAsync.when(
        data: (data) => _buildBody(context, ref, data),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load dashboard\n${e.toString()}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, DashboardEntity dashboard) {
    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            // Greeting Header
            Text(dashboard.businessName ?? 'Seller Dashboard', style: AppTextStyles.headlineLG),
            const SizedBox(height: 4),
            Text(
              dashboard.city ?? 'Overview',
              style: AppTextStyles.bodyMD.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 40),

            // Scan User QR Hero Card
            _buildScanHero(context),
            const SizedBox(height: 32),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.confirmation_number_rounded,
                    label: "TODAY'S REDEMPTIONS",
                    value: "${dashboard.todaysRedemptions}",
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today_rounded,
                    label: "THIS WEEK",
                    value: "${dashboard.thisWeekRedemptions}",
                    secondaryLabel: "Past 7 Days",
                    iconColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Financial Ledger Section
            _buildSectionHeader(
              'Financial Ledger',
              Icons.account_balance_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildLedgerCard(dashboard),
            const SizedBox(height: 40),

            // Recent Redemptions Section
            _buildSectionHeader(
              'Recent Redemptions',
              null,
              trailing: TextButton(
                onPressed: () => context.go('/history'),
                child: Text(
                  'View All',
                  style: AppTextStyles.labelSM.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildRedemptionsList(dashboard.recentRedemptions),

            const SizedBox(height: 120), // Padding for Bottom Nav
          ],
        ),
      ),
    );
  }

  Widget _buildScanHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          // QR Icon Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Scan User QR',
                  style: AppTextStyles.headlineSM.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Instantly verify coupons',
                  style: AppTextStyles.bodySM.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Compact Action Button
          ElevatedButton(
            onPressed: () => context.go('/scan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 0,
            ),
            child: const Icon(Icons.arrow_forward_rounded, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    String? trend,
    String? secondaryLabel,
    required Color iconColor,
  }) {
    return Container(
      height: 189, // Fixed height for consistency
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribute content evenly
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (trend != null)
                Text(
                  trend,
                  style: AppTextStyles.labelSM.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (secondaryLabel != null)
                Text(
                  secondaryLabel,
                  style: AppTextStyles.labelSM.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSM.copyWith(
                  letterSpacing: 1.1,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.headlineLG.copyWith(
                  fontSize: 40,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData? icon, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyles.headlineSM),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: AppColors.onSurface.withOpacity(0.6), size: 20),
            ],
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildLedgerCard(DashboardEntity dashboard) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          _buildLedgerItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'COMMISSION OWED',
            value: '₹${dashboard.commissionOwed.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildLedgerItem(
            icon: Icons.monetization_on_outlined,
            label: 'COIN RECEIVABLE',
            value: '₹${dashboard.coinReceivable.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerItem({
    required IconData icon,
    required String label,
    required String value,
    String? status,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.labelSM.copyWith(
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (status != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.labelSM.copyWith(
                          color: Colors.orange[800],
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // Right side: Amount
          Text(
            value,
            style: AppTextStyles.headlineSM.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionsList(List<RecentRedemptionEntity> redemptions) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          if (redemptions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No recent redemptions',
                style: AppTextStyles.bodyMD.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
            ),
          ...redemptions.map((r) => _buildRedemptionItem(
                r.couponName,
                'Ref: ${r.id.substring(0, 8)}', // Using shortened ID instead of location, since we don't have location per coupon
                '+₹${r.amount.toStringAsFixed(2)}',
                Colors.green,
              )),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.textSecondary.withOpacity(0.4),
              ),
              const SizedBox(width: 8),
              Text(
                'DATA SYNCS FOR EVERY NEW TRANSACTION',
                style: AppTextStyles.labelSM.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionItem(
    String title,
    String sub,
    String amount,
    Color amountColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMD.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(sub, style: AppTextStyles.bodySM.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyMD.copyWith(
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
