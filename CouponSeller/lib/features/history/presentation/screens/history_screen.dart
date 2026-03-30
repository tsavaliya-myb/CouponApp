// lib/features/history/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/history_entity.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int _selectedPeriodIndex = 0; // 0: This Week, 1: This Month, 2: ALL

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          // Timeframe Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: _buildTimeframeSelector(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Logs List
          Expanded(
            child: historyAsync.when(
              data: (history) => _buildList(history.redemptions),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, st) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load history', style: AppTextStyles.bodyMD),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.read(historyNotifierProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<RedemptionEntity> redemptions) {
    if (redemptions.isEmpty) {
      return Center(
        child: Text(
          'No redemptions found.',
          style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => ref.read(historyNotifierProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxxl,
          0,
          AppSpacing.xxxl,
          120, // Bottom Nav Padding
        ),
        itemCount: redemptions.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final data = redemptions[index];
          return _RedemptionLogCard(data: data);
        },
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTimeframeTab(0, 'this_week', 'This Week'),
          _buildTimeframeTab(1, 'this_month', 'This Month'),
          _buildTimeframeTab(2, 'all', 'ALL'),
        ],
      ),
    );
  }

  Widget _buildTimeframeTab(int index, String period, String label) {
    bool isSelected = _selectedPeriodIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedPeriodIndex == index) return;
          setState(() => _selectedPeriodIndex = index);
          ref.read(historyNotifierProvider.notifier).setPeriod(period);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSM.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Removed mock data
}

class _RedemptionLogCard extends StatelessWidget {
  final RedemptionEntity data;

  const _RedemptionLogCard({required this.data});

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFB3CCFF), // Dynamic color could be used
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  _getInitials(data.userName),
                  style: AppTextStyles.bodyMD.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              
              // Name & Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data.userName,
                          style: AppTextStyles.headlineSM.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary),
                        children: [
                          const TextSpan(text: 'Coupon: '),
                          TextSpan(
                            text: data.couponType,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003461)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(data.redeemedAt),
                      style: AppTextStyles.bodySM.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          // Bottom Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BILL AMOUNT',
                    style: AppTextStyles.labelSM.copyWith(
                      fontSize: 8,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${data.billAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.headlineSM.copyWith(fontSize: 20),
                  ),
                ],
              ),
              
              // Coins Highlight
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFEA80), Color(0xFFFFD700)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Color(0xFFB8860B), size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COINS USED',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Color(0xFF665500),
                          ),
                        ),
                        Text(
                          '${data.coinsUsed.toInt()}',
                          style: AppTextStyles.headlineSM.copyWith(
                            fontSize: 18,
                            color: const Color(0xFF332A00),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFC7F3C7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'VERIFIED',
        style: TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} • '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
