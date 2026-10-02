import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/influencers_provider.dart';
import 'package:Coupon360/features/wallet/presentation/providers/wallet_provider.dart';

class InfluencerDetailScreen extends ConsumerWidget {
  final String id;
  const InfluencerDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(influencerDetailProvider(id));
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      appBar: AppBar(
        title: Text('Creator Profile', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: detailAsync.when(
        data: (inf) {
          final services = inf['services'] as List? ?? [];
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 48),
                ),
                const SizedBox(height: 16),
                Text(inf['displayName'] ?? '', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(inf['niche']?['name'] ?? '', style: AppTextStyles.heading3.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatCol('${(inf['totalFollowers'] ?? 0) / 1000}k', 'Followers'),
                    const SizedBox(width: 32),
                    _buildStatCol('${services.length}', 'Services'),
                  ],
                ),
                const SizedBox(height: 24),
                
                if (inf['bio'] != null) ...[
                  Text(inf['bio'], textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 32),
                ],

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Available Services', style: AppTextStyles.heading2),
                ),
                const SizedBox(height: 16),
                
                if (services.isEmpty)
                  const Text('No active services currently.')
                else
                  ...services.map((s) => _buildServiceCard(context, ref, s, walletAsync)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStatCol(String val, String label) {
    return Column(
      children: [
        Text(val, style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context, 
    WidgetRef ref, 
    dynamic service,
    AsyncValue walletAsync,
    
  ) {
    final price = (service['discountedPrice'] ?? service['price']) as num;
    final int userCoins = walletAsync.asData?.value.coinBalance ?? 0;
    
    // Calculate max coins that can be used
    final int maxCoins = 100;
    final double coinVal = 0.1;

    final coinsToUse = userCoins > maxCoins ? maxCoins : userCoins;
    final discountFromCoins = coinsToUse * coinVal;
    
    // We can't use more coins than the price
    final actualCoinsUsed = discountFromCoins > price ? (price / coinVal).floor() : coinsToUse;
    final actualDiscount = actualCoinsUsed * coinVal;
    final finalPrice = price - actualDiscount;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service['name'], style: AppTextStyles.heading2),
          const SizedBox(height: 8),
          if (service['description'] != null)
            Text(service['description'], style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('₹$price', style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
              const Spacer(),
              Text('${service['deliveryDays']} days', style: AppTextStyles.label),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _confirmBooking(
                context, 
                ref, 
                service, 
                price, 
                actualCoinsUsed, 
                actualDiscount, 
                finalPrice
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Book Now'),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(
    BuildContext context, 
    WidgetRef ref, 
    dynamic service,
    num originalPrice,
    int coinsUsed,
    double coinDiscount,
    num finalPrice,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Confirm Booking', style: AppTextStyles.heading2),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Service Price'),
                  Text('₹$originalPrice', style: AppTextStyles.heading3),
                ],
              ),
              const SizedBox(height: 12),
              if (coinsUsed > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Coin Discount ($coinsUsed coins)'),
                    Text('-₹${coinDiscount.toStringAsFixed(2)}', style: AppTextStyles.heading3.copyWith(color: Colors.green)),
                  ],
                ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Payable', style: AppTextStyles.heading2),
                  Text('₹${finalPrice.toStringAsFixed(2)}', style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Consumer(builder: (context, ref, _) {
                  final bookingState = ref.watch(bookInfluencerServiceProvider);
                  return ElevatedButton(
                    onPressed: bookingState.isLoading ? null : () async {
                      final success = await ref.read(bookInfluencerServiceProvider.notifier).book(
                        service['id'],
                        coinsUsed,
                        coinDiscount,
                      );
                      if (success && ctx.mounted) {
                        ctx.pop();
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Booking request sent successfully!')));
                        ref.read(walletProvider.notifier).refresh();
                      } else if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Failed to book service.')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: bookingState.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Booking'),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
