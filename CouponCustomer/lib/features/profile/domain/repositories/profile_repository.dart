import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';
import '../../data/models/area_model.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/models/leaderboard_user_model.dart';

import '../../data/models/referral_stats_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getUser();
  Future<Either<Failure, UserModel>> updateUser(Map<String, dynamic> data);
  Future<Either<Failure, List<AreaModel>>> getAreas(String cityId);
  Future<Either<Failure, List<CityModel>>> getCities();
  Future<Either<Failure, UserSettingsModel>> getUserSettings();
  Future<Either<Failure, List<LeaderboardUserModel>>> getLeaderboard({
    required String type,
    required String timeFrame,
  });
  Future<Either<Failure, ReferralStatsModel>> getReferralStats();
}
