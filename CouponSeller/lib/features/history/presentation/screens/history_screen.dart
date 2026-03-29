// lib/features/history/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedPeriodIndex = 0; // 0: Today, 1: This Week, 2: This Month

  @override
  Widget build(BuildContext context) {
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxxl,
                0,
                AppSpacing.xxxl,
                120, // Bottom Nav Padding
              ),
              itemCount: _getMockData().length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final data = _getMockData()[index];
                return _RedemptionLogCard(data: data);
              },
            ),
          ),
        ],
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
          _buildTimeframeTab(0, 'Today'),
          _buildTimeframeTab(1, 'This Week'),
          _buildTimeframeTab(2, 'This Month'),
        ],
      ),
    );
  }

  Widget _buildTimeframeTab(int index, String label) {
    bool isSelected = _selectedPeriodIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriodIndex = index),
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

  List<Map<String, dynamic>> _getMockData() {
    return [
      {
        'name': 'Mihir Shah',
        'initials': 'MS',
        'avatarColor': const Color(0xFFB3CCFF),
        'coupon': 'SAVE50_DELUXE',
        'date': '12 Oct 2023 • 02:45 PM',
        'billAmount': '₹4,250.00',
        'coinsUsed': '450',
      },
      {
        'name': 'Ankit Kumar',
        'initials': 'AK',
        'avatarColor': const Color(0xFFB3FFB3),
        'coupon': 'FIRST_WALK_FREE',
        'date': '12 Oct 2023 • 01:12 PM',
        'billAmount': '₹1,100.00',
        'coinsUsed': '200',
      },
      {
        'name': 'Rahul Jain',
        'initials': 'RJ',
        'avatarColor': const Color(0xFFFFCCB3),
        'coupon': 'FESTIVE_BOGO',
        'date': '12 Oct 2023 • 11:30 AM',
        'billAmount': '₹8,900.00',
        'coinsUsed': '1,250',
      },
      {
        'name': 'Praveen Nair',
        'initials': 'PN',
        'avatarColor': const Color(0xFFE4E6EB),
        'coupon': 'WEEKEND_REWARD',
        'date': '12 Oct 2023 • 09:05 AM',
        'billAmount': '₹2,400.00',
        'coinsUsed': '310',
      },
    ];
  }
}

class _RedemptionLogCard extends StatelessWidget {
  final Map<String, dynamic> data;

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
                  color: data['avatarColor'],
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  data['initials'],
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
                          data['name'],
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
                            text: data['coupon'],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003461)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data['date'],
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
                    data['billAmount'],
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
                          data['coinsUsed'],
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
}
