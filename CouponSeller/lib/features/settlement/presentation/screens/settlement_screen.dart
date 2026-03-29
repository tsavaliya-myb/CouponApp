// lib/features/settlement/presentation/screens/settlement_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class SettlementScreen extends StatefulWidget {
  const SettlementScreen({super.key});

  @override
  State<SettlementScreen> createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            
            // Outstandings Header
            _buildOutstandingHero(),
            const SizedBox(height: 32),

            // Top Actions
            _buildTopActions(),
            const SizedBox(height: 48),

            // Statement Periods
            _buildSectionTitle('Active Statements'),
            const SizedBox(height: AppSpacing.md),
            _buildStatementCard(
              period: 'Oct 14 - Oct 20, 2023',
              isPending: true,
              redemptions: '22',
              commission: '₹1,100',
              coins: '₹220',
              isExpanded: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildStatementCard(
              period: 'Oct 07 - Oct 13, 2023',
              isPending: false,
              redemptions: '45',
              commission: '₹2,250',
              coins: '₹450',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildStatementCard(
              period: 'Sep 30 - Oct 06, 2023',
              isPending: false,
              redemptions: '30',
              commission: '₹1,500',
              coins: '₹300',
            ),
            
            const SizedBox(height: 48),

            // Analytics Section
            _buildSectionTitle('Settlement Analytics'),
            const SizedBox(height: AppSpacing.md),
            _buildAnalyticsCard(
              icon: Icons.trending_up_rounded,
              label: 'AVG. WEEKLY REVENUE',
              value: '₹1,650.00',
              color: AppColors.primary,
              textColor: Colors.white,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildAnalyticsCard(
              icon: Icons.layers_outlined,
              label: 'COIN SHARE CONTRIBUTION',
              value: '12.5%',
              color: const Color(0xFFFFEA80),
              textColor: const Color(0xFF332A00),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildAnalyticsCard(
              icon: Icons.speed_rounded,
              label: 'PAYOUT SPEED',
              value: 'Instant',
              color: const Color(0xFFA6EFA6),
              textColor: const Color(0xFF1B5E20),
            ),

            const SizedBox(height: 120), // Bottom Nav Space
          ],
        ),
      ),
    );
  }

  Widget _buildOutstandingHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity), // Centering hack for column
        Text(
          'TOTAL OUTSTANDING',
          style: AppTextStyles.labelSM.copyWith(
            letterSpacing: 1.5,
            fontSize: 10,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹4,850.00',
          style: AppTextStyles.headlineLG.copyWith(
            fontSize: 48,
            letterSpacing: -2,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildTopActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Download Report',
              style: AppTextStyles.buttonText.copyWith(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 24),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headlineSM.copyWith(fontSize: 18),
    );
  }

  Widget _buildStatementCard({
    required String period,
    required bool isPending,
    required String redemptions,
    required String commission,
    required String coins,
    bool isExpanded = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATEMENT PERIOD',
                    style: AppTextStyles.labelSM.copyWith(
                      fontSize: 8,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    period,
                    style: AppTextStyles.headlineSM.copyWith(fontSize: 18),
                  ),
                ],
              ),
              _buildStatusBadge(isPending),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildStatDetail('Redemptions', redemptions),
              const SizedBox(width: 48),
              _buildStatDetail('Commission Owed', commission),
            ],
          ),
          const SizedBox(height: 24),
          _buildCoinStat(coins),
          const SizedBox(height: 32),
          Center(
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSM.copyWith(fontSize: 9),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineSM.copyWith(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildCoinStat(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coin Compensation',
          style: AppTextStyles.labelSM.copyWith(fontSize: 9),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.orange, size: 16),
            const SizedBox(width: 8),
            Text(
              value,
              style: AppTextStyles.headlineSM.copyWith(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isPending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? const Color(0xFFFFF3CD) : const Color(0xFFD1E7DD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPending ? 'Pending' : 'Paid',
        style: TextStyle(
          color: isPending ? const Color(0xFF856404) : const Color(0xFF0F5132),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor.withOpacity(0.6), size: 28),
          const SizedBox(height: 40),
          Text(
            label,
            style: AppTextStyles.labelSM.copyWith(
              fontSize: 9,
              color: textColor.withOpacity(0.6),
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineSM.copyWith(
              fontSize: 28,
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
