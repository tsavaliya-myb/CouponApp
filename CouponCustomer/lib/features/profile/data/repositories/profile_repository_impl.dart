import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';
import '../models/area_model.dart';
import '../models/user_settings_model.dart';
import '../models/leaderboard_user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final user = await remoteDataSource.getUser();
      return Right(user);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(Map<String, dynamic> data) async {
    try {
      final user = await remoteDataSource.updateUser(data);
      return Right(user);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<AreaModel>>> getAreas(String cityId) async {
    try {
      final areas = await remoteDataSource.getAreas(cityId);
      return Right(areas);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CityModel>>> getCities() async {
    try {
      final cities = await remoteDataSource.getCities();
      return Right(cities);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserSettingsModel>> getUserSettings() async {
    try {
      final settings = await remoteDataSource.getUserSettings();
      return Right(settings);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardUserModel>>> getLeaderboard({
    required String type,
    required String timeFrame,
  }) async {
    try {
      final leaderboard = await remoteDataSource.getLeaderboard(
        type: type,
        timeFrame: timeFrame,
      );
      return Right(leaderboard);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }
}
