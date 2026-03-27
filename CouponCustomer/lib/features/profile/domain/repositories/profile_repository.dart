import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';
import '../../data/models/area_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getUser();
  Future<Either<Failure, UserModel>> updateUser(Map<String, dynamic> data);
  Future<Either<Failure, List<AreaModel>>> getAreas(String cityId);
  Future<Either<Failure, List<CityModel>>> getCities();
}
