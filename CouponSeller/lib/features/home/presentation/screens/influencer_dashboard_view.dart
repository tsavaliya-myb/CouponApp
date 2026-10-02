import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../providers/influencer_dashboard_provider.dart';

class InfluencerDashboardView extends ConsumerWidget {
  const InfluencerDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(influencerDashboardNotifierProvider);

    return dashboardAsync.when(
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
              onPressed: () => ref.read(influencerDashboardNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, Map<String, dynamic> dashboard) {
    return RefreshIndicator(
      onRefresh: () => ref.read(influencerDashboardNotifierProvider.notifier).refresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            Text('Creator Dashboard', style: AppTextStyles.headlineLG),
            const SizedBox(height: 4),
            Text(
              'Manage your services and bookings',
              style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),

            // Services Hero Card
            _buildManageServicesHero(context),
            const SizedBox(height: 32),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.pending_actions_rounded,
                    label: "PENDING",
                    value: "${dashboard['pendingBookings'] ?? 0}",
                    iconColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle_outline_rounded,
                    label: "DELIVERED",
                    value: "${dashboard['deliveredBookings'] ?? 0}",
                    iconColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.account_balance_wallet_rounded,
                    label: "REVENUE",
                    value: "₹${dashboard['totalRevenue'] ?? 0}",
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.cancel_outlined,
                    label: "CANCELLED",
                    value: "${dashboard['cancelledBookings'] ?? 0}",
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // Recent Bookings
            Text(
              'Recent Requests',
              style: AppTextStyles.titleLG,
            ),
            const SizedBox(height: 16),
            if ((dashboard['recentBookings'] as List).isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text('No requests yet.', style: AppTextStyles.bodyMD),
                ),
              )
            else
              ...((dashboard['recentBookings'] as List).map((booking) => _buildBookingTile(context, ref, booking))),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildManageServicesHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Packages', style: AppTextStyles.titleLG),
                    Text('Create and update your offerings', style: AppTextStyles.bodySM),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.push('/influencer-services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Manage Services'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.headlineMD,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSM.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTile(BuildContext context, WidgetRef ref, dynamic booking) {
    return InkWell(
      onTap: () => _showBookingActionModal(context, ref, booking),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking['service']?['name'] ?? 'Service', style: AppTextStyles.titleMD),
                  const SizedBox(height: 4),
                  Text(
                    booking['user']?['name'] ?? 'User',
                    style: AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${booking['pricePaid']}',
                  style: AppTextStyles.titleMD.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                _buildStatusBadge(booking['status'] ?? 'ENQUIRED'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingActionModal(BuildContext context, WidgetRef ref, dynamic booking) {
    final status = booking['status'];
    if (status == 'CANCELLED' || status == 'DELIVERED') return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Update Booking Status', style: AppTextStyles.titleLG),
              const SizedBox(height: 24),
              if (status == 'ENQUIRED') ...[
                ElevatedButton(
                  onPressed: () => _updateBooking(context, ref, booking['id'], 'ACCEPTED'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  child: const Text('Accept Request'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _updateBooking(context, ref, booking['id'], 'CANCELLED'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ] else if (status == 'ACCEPTED') ...[
                ElevatedButton(
                  onPressed: () => _updateBooking(context, ref, booking['id'], 'IN_PROGRESS'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  child: const Text('Mark as In Progress'),
                ),
              ] else if (status == 'IN_PROGRESS') ...[
                ElevatedButton(
                  onPressed: () => _updateBooking(context, ref, booking['id'], 'DELIVERED'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('Mark as Delivered'),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateBooking(BuildContext context, WidgetRef ref, String id, String newStatus) async {
    try {
      final apiClient = getIt<ApiClient>();
      await apiClient.client.patch('/influencers/me/bookings/$id', data: {'status': newStatus});
      ref.read(influencerDashboardNotifierProvider.notifier).refresh();
      if (context.mounted) context.pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update status')));
      }
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'ENQUIRED':
      case 'PENDING':
        color = Colors.orange;
        break;
      case 'ACCEPTED':
      case 'IN_PROGRESS':
        color = Colors.blue;
        break;
      case 'DELIVERED':
        color = Colors.green;
        break;
      case 'CANCELLED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSM.copyWith(color: color),
      ),
    );
  }
}
