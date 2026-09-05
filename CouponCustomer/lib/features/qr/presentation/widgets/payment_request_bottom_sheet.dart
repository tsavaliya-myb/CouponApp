// lib/features/qr/presentation/widgets/payment_request_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../services/notification_service.dart';

class PaymentRequestBottomSheet extends StatelessWidget {
  final PaymentRequestData data;

  const PaymentRequestBottomSheet({super.key, required this.data});

  static final _log = Logger();

  Future<void> _launchUpi(BuildContext context) async {
    // upi:// deep link — opens system UPI app chooser (GPay, PhonePe, Paytm, etc.)
    // am = amount, tn = transaction note, cu = currency
    final uri = Uri.parse(
      'upi://pay'
      '?am='
      '&tn=CouponApp%20Payment'
      '&cu=INR',
    );

    _log.i('[PaymentSheet] Launching UPI: $uri');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _log.w('[PaymentSheet] No UPI app found on device');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No UPI app found. Please pay by cash.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.dsSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dsOnSurface.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.dsPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  color: AppColors.dsPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Due',
                      style: AppTextStyles.dsTitleLg.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.dsOnSurface,
                      ),
                    ),
                    Text(
                      'at ',
                      style: AppTextStyles.dsBodyMd.copyWith(
                        color: AppColors.dsOnSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bill summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.dsSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildRow('Gross Bill', '₹'),
                const SizedBox(height: 12),
                _buildRow(
                  'Coupon Discount',
                  '-₹',
                  isDiscount: true,
                ),
                const SizedBox(height: 16),

                // Dotted divider
                LayoutBuilder(builder: (ctx, constraints) {
                  final dashCount = (constraints.maxWidth / 8).floor();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dashCount, (_) {
                      return Container(
                        width: 4,
                        height: 1,
                        color: AppColors.dsOnSurface.withOpacity(0.15),
                      );
                    }),
                  );
                }),

                const SizedBox(height: 16),

                // Final amount — prominent
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You Pay',
                      style: AppTextStyles.dsTitleLg.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.dsOnSurface,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.dsPrimary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '₹',
                          style: AppTextStyles.dsTitleLg.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dsPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Pay via UPI button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchUpi(context),
              icon: const Icon(Icons.account_balance_wallet_rounded, size: 20),
              label: const Text('Pay via UPI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dsPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: AppTextStyles.dsLabelLg.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Pay by cash button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.dsOnSurface.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.dsOnSurface.withOpacity(0.15)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: AppTextStyles.dsLabelLg.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              child: const Text("I'll Pay by Cash"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.6)),
        ),
        Text(
          value,
          style: AppTextStyles.dsBodyMd.copyWith(
            fontWeight: FontWeight.w700,
            color: isDiscount ? const Color(0xFF22A55B) : AppColors.dsOnSurface,
          ),
        ),
      ],
    );
  }
}
