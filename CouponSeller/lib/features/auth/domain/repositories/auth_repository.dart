import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result_entity.dart';
import '../entities/seller_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> sendOtp({required String phone});
  Future<Either<Failure, AuthResultEntity>> verifyOtp({required String phone, required String otp});
  Future<Either<Failure, SellerEntity>> registerSeller(RegisterSellerParams params);
}
