import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';

@Injectable(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDatasource _remoteDatasource;

  LocationRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<CityEntity>>> getCities() async {
    try {
      final response = await _remoteDatasource.getCities();
      if (response.success) {
        final cities = response.data.map((model) => CityEntity(
          id: model.id,
          name: model.name,
          status: model.status,
        )).toList();
        return Right(cities);
      } else {
        return Left(ServerFailure(message: 'Failed to fetch cities'));
      }
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AreaEntity>>> getAreas(String cityId) async {
    try {
      final response = await _remoteDatasource.getAreas(cityId);
      if (response.success) {
        final areas = response.data.map((model) => AreaEntity(
          id: model.id,
          name: model.name,
          cityId: model.cityId,
          isActive: model.isActive,
        )).toList();
        return Right(areas);
      } else {
        return Left(ServerFailure(message: 'Failed to fetch areas'));
      }
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
