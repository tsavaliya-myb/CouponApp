// lib/core/widgets/network_aware_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_service.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Wraps any widget that needs live network data.
/// Shows an offline banner when disconnected.
class NetworkAwareWidget extends ConsumerWidget {
  final Widget child;
  final Widget? offlineChild;
  final bool showBannerOnly; // show banner on top instead of replacing

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.offlineChild,
    this.showBannerOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);

    return connectivity.when(
      data: (isConnected) {
        if (!isConnected && !showBannerOnly) {
          return offlineChild ?? const OfflineBanner();
        }
        if (!isConnected && showBannerOnly) {
          return Column(
            children: [
              const _OfflineTopBanner(),
              Expanded(child: child),
            ],
          );
        }
        return child;
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

/// Full-screen offline placeholder
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
          SizedBox(height: AppSpacing.md),
          Text('You\'re offline', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// Small top banner shown when offline in banner-only mode
class _OfflineTopBanner extends StatelessWidget {
  const _OfflineTopBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 14, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'No internet connection',
            style: AppTextStyles.label.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
