import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<CityEntity>>> getCities();
  Future<Either<Failure, List<AreaEntity>>> getAreas(String cityId);
}
