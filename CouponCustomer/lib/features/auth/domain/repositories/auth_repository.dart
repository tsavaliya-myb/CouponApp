// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sends OTP to the given phone number.
  /// Returns a success message string on success.
  Future<Either<Failure, String>> sendOtp({required String phone});

  /// Verifies OTP and returns the authenticated [UserEntity].
  /// JWT tokens are stored internally by the repository.
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Clears stored tokens and invalidates session.
  Future<Either<Failure, Unit>> logout();
}
