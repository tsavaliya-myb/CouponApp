import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/leaderboard_provider.dart';

class LeaderboardSection extends ConsumerWidget {
  const LeaderboardSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(leaderboardFilterProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '🏆 Community Leaderboard',
            style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        
        // --- Segmented Control for Type ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.dsSurfaceContainerHighest,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    title: 'Top Savers',
                    isSelected: filter.type == 'savers',
                    onTap: () => ref
                        .read(leaderboardFilterProvider.notifier)
                        .state = LeaderboardFilter(
                            type: 'savers', timeFrame: filter.timeFrame),
                  ),
                ),
                Expanded(
                  child: _TypeButton(
                    title: 'Top Spenders',
                    isSelected: filter.type == 'spenders',
                    onTap: () => ref
                        .read(leaderboardFilterProvider.notifier)
                        .state = LeaderboardFilter(
                            type: 'spenders', timeFrame: filter.timeFrame),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --- Time Filter Chips ---
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _TimeChip(
                title: 'This Week',
                isSelected: filter.timeFrame == 'week',
                onTap: () => ref
                    .read(leaderboardFilterProvider.notifier)
                    .state = LeaderboardFilter(
                        type: filter.type, timeFrame: 'week'),
              ),
              const SizedBox(width: 8),
              _TimeChip(
                title: 'This Month',
                isSelected: filter.timeFrame == 'month',
                onTap: () => ref
                    .read(leaderboardFilterProvider.notifier)
                    .state = LeaderboardFilter(
                        type: filter.type, timeFrame: 'month'),
              ),
              const SizedBox(width: 8),
              _TimeChip(
                title: 'All Time',
                isSelected: filter.timeFrame == 'all_time',
                onTap: () => ref
                    .read(leaderboardFilterProvider.notifier)
                    .state = LeaderboardFilter(
                        type: filter.type, timeFrame: 'all_time'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --- Leaderboard List ---
        leaderboardAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.dsPrimary),
            ),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'Could not load leaderboard\nBackend endpoint missing or offline',
                textAlign: TextAlign.center,
                style: AppTextStyles.dsBodyMd
                    .copyWith(color: AppColors.dsTertiaryPink),
              ),
            ),
          ),
          data: (users) {
            if (users.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'No data available yet.',
                    style: AppTextStyles.dsBodyMd.copyWith(
                      color: AppColors.dsOnSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                return _LeaderboardRow(user: user, filterType: filter.type);
              },
            );
          },
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dsPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.dsLabelMd.copyWith(
              fontSize: 14,
              color: isSelected ? AppColors.dsSurfaceContainerLowest : AppColors.dsOnSurface,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.dsPrimaryContainer
              : AppColors.dsSurfaceContainerLow,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected
                ? AppColors.dsPrimary
                : AppColors.dsOnSurface.withOpacity(0.1),
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.dsLabelMd.copyWith(
            color: isSelected ? AppColors.dsOnSurface : AppColors.dsOnSurface.withOpacity(0.6),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final dynamic user;
  final String filterType;

  const _LeaderboardRow({required this.user, required this.filterType});

  @override
  Widget build(BuildContext context) {
    final isTop3 = user.rank <= 3;
    
    // Aesthetic handling for top 3 using AppColors
    Color bgColor = AppColors.dsSurfaceContainerLowest;
    Color rankColor = AppColors.dsOnSurface.withOpacity(0.5);
    
    if (user.rank == 1) {
      bgColor = AppColors.dsPrimaryContainer.withOpacity(0.3);
      rankColor = AppColors.dsPrimary;
    } else if (user.rank == 2) {
      bgColor = AppColors.dsSurfaceContainerHighest.withOpacity(0.5);
      rankColor = AppColors.dsOnSurface.withOpacity(0.8);
    } else if (user.rank == 3) {
      bgColor = AppColors.dsSurfaceContainerLow;
      rankColor = AppColors.dsOnSurface.withOpacity(0.6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isTop3 ? Border.all(color: rankColor.withOpacity(0.2)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '#${user.rank}',
              style: AppTextStyles.dsLabelMd.copyWith(
                fontSize: 14,
                color: rankColor,
                fontWeight: isTop3 ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.dsPrimary.withOpacity(0.1),
            backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child: user.avatarUrl == null
                ? Icon(Icons.person, color: AppColors.dsPrimary, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.name,
              style: AppTextStyles.dsBodyMd.copyWith(
                fontWeight: isTop3 ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '₹${user.metricValue.toStringAsFixed(0)}',
            style: AppTextStyles.dsBodyMd.copyWith(
              color: filterType == 'savers' ? AppColors.dsSecondaryMint : AppColors.dsPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
