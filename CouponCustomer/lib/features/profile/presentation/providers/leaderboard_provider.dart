import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../data/models/leaderboard_user_model.dart';
import '../../domain/repositories/profile_repository.dart';

class LeaderboardFilter {
  final String type;
  final String timeFrame;

  const LeaderboardFilter({
    this.type = 'savers',
    this.timeFrame = 'month',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardFilter &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          timeFrame == other.timeFrame;

  @override
  int get hashCode => type.hashCode ^ timeFrame.hashCode;
}

final leaderboardFilterProvider = StateProvider<LeaderboardFilter>((ref) {
  return const LeaderboardFilter();
});

final leaderboardProvider = FutureProvider.autoDispose<List<LeaderboardUserModel>>((ref) async {
  final filter = ref.watch(leaderboardFilterProvider);
  final repository = GetIt.I<ProfileRepository>();
  
  final result = await repository.getLeaderboard(
    type: filter.type,
    timeFrame: filter.timeFrame,
  );
  
  return result.fold(
    (failure) => throw failure.message,
    (data) => data,
  );
});
