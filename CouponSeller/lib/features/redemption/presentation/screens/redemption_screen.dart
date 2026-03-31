// lib/features/scan/presentation/screens/redemption_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/current_redemption_provider.dart';
import '../providers/redemption_provider.dart';
import '../../domain/entities/verify_user_entity.dart';

class RedemptionScreen extends ConsumerStatefulWidget {
  const RedemptionScreen({super.key});

  @override
  ConsumerState<RedemptionScreen> createState() => _RedemptionScreenState();
}

class _RedemptionScreenState extends ConsumerState<RedemptionScreen> {
  String? _selectedCouponId = '1';
  bool _applyCoins = false;
  final TextEditingController _amountController = TextEditingController();
  String? _paymentMethod; // 'CASH' or 'UPI'

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entity = ref.watch(currentRedemptionProvider);
    
    if (entity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No active scan data found.')),
      );
    }

    if (_selectedCouponId == '1' || _selectedCouponId == null) {
      if (entity.eligibleCoupons.isNotEmpty) {
        _selectedCouponId = entity.eligibleCoupons.first.id;
      } else {
        _selectedCouponId = '';
      }
    }

    ref.listen(redemptionProvider, (prev, next) {
      if (!next.isLoading && next.hasValue && next.value == true) {
        _showSuccess('Redemption completed');
        context.go('/dashboard');
      } else if (!next.isLoading && next.hasError) {
        _showError(next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface, // Clean backdrop
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('New Redemption', style: AppTextStyles.headlineSM),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              _buildUserIdentityCard(entity.user),
              const SizedBox(height: AppSpacing.xxxl),

              _buildCouponSelection(entity.eligibleCoupons),
              const SizedBox(height: AppSpacing.xxxl),

              _buildRedemptionDetails(entity.user),
              const SizedBox(height: AppSpacing.xxxl),

              _buildBillSummary(entity),
              const SizedBox(height: 120), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserIdentityCard(RedemptionUserEntity user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://api.dicebear.com/7.x/avataaars/png?seed=${user.name.replaceAll(' ', '')}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: AppTextStyles.headlineMD.copyWith(
                            fontSize: 22,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.secondary,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'SUBSCRIPTION ${user.hasActiveSubscription ? 'ACTIVE' : 'INACTIVE'}',
                          style: AppTextStyles.labelSM.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Available Rewards',
            style: AppTextStyles.bodySM.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Coins Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFFEA80,
                  ), // tertiary_fixed from design document concept
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Color(0xFF332A00),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${user.availableCoins.toInt()} Coins',
                      style: AppTextStyles.labelSM.copyWith(
                        color: const Color(0xFF332A00),
                        fontWeight: FontWeight.w800,
                      ),
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

  Widget _buildCouponSelection(List<EligibleCouponEntity> coupons) {
    if (coupons.isEmpty) {
       return const Padding(
         padding: EdgeInsets.symmetric(vertical: 20),
         child: Text('No applicable coupons found for this user.'),
       );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Applicable Coupon',
          style: AppTextStyles.headlineSM.copyWith(
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...coupons.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCouponItem(
            id: c.id,
            icon: Icons.percent_rounded,
            title: '${c.coupon.discountPct}% Flat Discount',
            subtitle: 'Valid on bills above ₹${c.coupon.minSpend}',
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildCouponItem({
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedCouponId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCouponId = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(color: AppColors.surfaceContainerLowest, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMD.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelSM.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: isSelected ? 6 : 2,
                ),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedemptionDetails(RedemptionUserEntity user) {
    final maxCoins = (user.availableCoins > 10) ? 10 : user.availableCoins.toInt();
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Redemption\nDetails',
            style: AppTextStyles.headlineMD.copyWith(
              fontSize: 32,
              color: AppColors.primary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter the bill amount and apply\nloyalty benefits.',
            style: AppTextStyles.bodySM.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          Text(
            'TOTAL BILL AMOUNT',
            style: AppTextStyles.labelSM.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),

          // Custom input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  '₹',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Apply Coins Toggle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEA80),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: Color(0xFF332A00),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apply max $maxCoins coins?',
                        style: AppTextStyles.bodyMD.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Save additional ₹${maxCoins.toStringAsFixed(2)}',
                        style: AppTextStyles.labelSM.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _applyCoins,
                  onChanged: (val) => setState(() => _applyCoins = val),
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.secondary,
                  inactiveTrackColor: AppColors.surfaceContainerHighest,
                  inactiveThumbColor: Colors.white,
                  trackOutlineColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary(VerifyUserEntity entity) {
    // Computations
    double billAmount = double.tryParse(_amountController.text) ?? 0.0;
    
    // Find selected coupon
    EligibleCouponEntity? selectedCoupon;
    try {
      selectedCoupon = entity.eligibleCoupons.firstWhere((c) => c.id == _selectedCouponId);
    } catch (_) {}

    double discountAmount = 0.0;
    if (selectedCoupon != null && billAmount >= selectedCoupon.coupon.minSpend) {
       discountAmount = billAmount * (selectedCoupon.coupon.discountPct / 100);
    }

    final maxCoins = (entity.user.availableCoins > 10) ? 10 : entity.user.availableCoins.toInt();
    double coinDeduction = _applyCoins ? maxCoins.toDouble() : 0.0;
    
    double finalAmount = billAmount - discountAmount - coinDeduction;
    if (finalAmount < 0) finalAmount = 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
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
          Text(
            'Bill Summary',
            style: AppTextStyles.headlineSM.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 24),

          _buildSummaryRow('Gross Subtotal', '₹${billAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Coupon Discount',
            '-₹${discountAmount.toStringAsFixed(2)}',
            isDiscount: true,
            badgeWidget: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFA6EFA6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedCoupon != null ? '${selectedCoupon.coupon.discountPct}% OFF' : '0% OFF',
                style: AppTextStyles.labelSM.copyWith(
                  fontSize: 8,
                  color: const Color(0xFF0F5132),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Coin Deduction',
            '-₹${coinDeduction.toStringAsFixed(2)}',
            isDiscount: true,
            badgeWidget: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(
                Icons.stars_rounded,
                color: Color(0xFFD4AF37),
                size: 14,
              ),
            ),
          ),

          const SizedBox(height: 24),
          // Dotted Divider
          LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 4.0;
              const dashSpace = 4.0;
              final dashCount =
                  (constraints.constrainWidth() / (dashWidth + dashSpace))
                      .floor();
              return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: List.generate(dashCount, (_) {
                  return SizedBox(
                    width: dashWidth,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 24),

          Text(
            'FINAL PAY AMOUNT',
            style: AppTextStyles.labelSM.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${finalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.headlineLG.copyWith(
                  fontSize: 36,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              Text(
                'Inclusive of\nall taxes',
                textAlign: TextAlign.right,
                style: AppTextStyles.labelSM.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Payment Method Selection
          Text(
            'Select Payment Mode',
            style: AppTextStyles.labelSM.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _paymentMethod = 'CASH'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _paymentMethod == 'CASH'
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _paymentMethod == 'CASH'
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'CASH',
                        style: AppTextStyles.bodyMD.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _paymentMethod == 'CASH'
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _paymentMethod = 'UPI'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _paymentMethod == 'UPI'
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _paymentMethod == 'UPI'
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'UPI',
                        style: AppTextStyles.bodyMD.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _paymentMethod == 'UPI'
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _paymentMethod == null || _selectedCouponId == null || ref.watch(redemptionProvider).isLoading 
                ? null 
                : () {
                    ref.read(redemptionProvider.notifier).confirmRedemption(
                      userCouponId: _selectedCouponId!,
                      billAmount: billAmount,
                      discountAmount: discountAmount,
                      coinsUsed: coinDeduction,
                    );
                  },
              icon: ref.watch(redemptionProvider).isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check_circle_outline_rounded, size: 20),
              label: Text(ref.watch(redemptionProvider).isLoading ? 'Processing...' : 'Confirm Redemption'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.surfaceContainerHighest,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: AppTextStyles.buttonText.copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String amount, {
    bool isDiscount = false,
    Widget? badgeWidget,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
        ),
        if (badgeWidget != null) badgeWidget,
        const Spacer(),
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDiscount ? AppColors.secondary : AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
