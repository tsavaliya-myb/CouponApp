// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/token_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._datasource, this._tokenService);

  @override
  Future<Either<Failure, String>> sendOtp({required String phone}) async {
    try {
      final result = await _datasource.sendOtp(phone: phone);
      return Right(result.data.message);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final result = await _datasource.verifyOtp(phone: phone, otp: otp);
      // Store JWT tokens securely
      await _tokenService.saveTokens(
        access: result.data.accessToken,
        refresh: result.data.refreshToken,
      );
      final userModel = result.data.user;
      return Right(UserEntity(
        id: userModel?.id ?? phone,
        phone: phone,
        name: userModel?.name,
        email: userModel?.email,
        cityId: userModel?.cityId,
        areaId: userModel?.areaId,
        status: userModel?.status ?? 'ACTIVE',
        isNewUser: result.data.isNewUser,
      ));
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (_) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _tokenService.clearTokens();
      return const Right(unit);
    } catch (_) {
      return Left(const ServerFailure(message: 'Failed to logout. Please try again.'));
    }
  }

  Failure _mapError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.connectionTimeout => const NetworkFailure(),
      DioExceptionType.receiveTimeout =>
        const ServerFailure(message: 'Request timed out.'),
      _ => switch (e.response?.statusCode) {
          401 => const UnauthorizedFailure(),
          404 => const NotFoundFailure('User not found.'),
          422 => ValidationFailure(
              _extractMessage(e, 'Invalid input. Please try again.'),
            ),
          429 => const ServerFailure(
              message: 'Too many requests. Please wait and try again.',
            ),
          _ => ServerFailure(
              statusCode: e.response?.statusCode,
              message: _extractMessage(e, 'Something went wrong.'),
            ),
        },
    };
  }

  String _extractMessage(DioException e, String fallback) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return (data['message'] ?? data['error'] ?? fallback).toString();
      }
    } catch (_) {}
    return fallback;
  }
}
