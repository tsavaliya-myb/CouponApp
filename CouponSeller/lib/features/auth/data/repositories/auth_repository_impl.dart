import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/token_service.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._remoteDatasource, this._tokenService);

  @override
  Future<Either<Failure, String>> sendOtp({required String phone}) async {
    try {
      final response = await _remoteDatasource.sendOtp(phone: phone);
      if (response.success) {
        return Right(response.data.message);
      } else {
        return Left(ServerFailure(message: 'Failed to send OTP'));
      }
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResultEntity>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _remoteDatasource.verifyOtp(phone: phone, otp: otp);
      if (response.success) {
        final data = response.data;
        if (data.isRegistered == true && data.accessToken != null && data.refreshToken != null) {
          await _tokenService.saveTokens(
            access: data.accessToken!,
            refresh: data.refreshToken!,
          );
        }
        
        return Right(AuthResultEntity(
          isRegistered: data.isRegistered,
          registrationToken: data.registrationToken,
          status: data.status,
        ));
      } else {
        return Left(ServerFailure(message: 'Failed to verify OTP'));
      }
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
