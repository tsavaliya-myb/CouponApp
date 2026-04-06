// lib/core/providers/subscription_provider.dart
//
// Single source of truth for "is the current user a subscriber?"
// The UserModel.status == 'ACTIVE' already maps to an active subscription
// (consistent with QrScreen's existing _buildExpiredState check).
//
// To force non-subscriber mode for debugging, set [kForceMockSubscription] to true.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

// Set to true to always show the non-subscriber experience (for UI testing).
const bool kForceMockSubscription = false;

/// Returns whether the current user has an active subscription.
/// Reads from [profileProvider]; emits `false` while loading or on error
/// (so guards show the subscribe gate, not a crash).
final isSubscribedProvider = Provider<bool>((ref) {
  if (kForceMockSubscription) return false;

  final profileAsync = ref.watch(profileProvider);
  return profileAsync.when(
    data: (user) => user.subscriptionStatus == 'ACTIVE',
    loading: () => false,
    error: (_, __) => false,
  );
});
