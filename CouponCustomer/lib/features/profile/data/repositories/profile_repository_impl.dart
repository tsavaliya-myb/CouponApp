import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';
import '../models/area_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final user = await remoteDataSource.getUser();
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(Map<String, dynamic> data) async {
    try {
      final user = await remoteDataSource.updateUser(data);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AreaModel>>> getAreas(String cityId) async {
    try {
      final areas = await remoteDataSource.getAreas(cityId);
      return Right(areas);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
