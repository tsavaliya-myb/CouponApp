import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/models/referral_stats_model.dart';
import '../../../../core/di/injection.dart';

part 'referral_provider.g.dart';

@riverpod
class ReferralStats extends _$ReferralStats {
  @override
  FutureOr<ReferralStatsModel> build() async {
    return _fetchStats();
  }

  Future<ReferralStatsModel> _fetchStats() async {
    final repository = getIt<ProfileRepository>();
    final result = await repository.getReferralStats();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (stats) => stats,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStats());
  }
}
