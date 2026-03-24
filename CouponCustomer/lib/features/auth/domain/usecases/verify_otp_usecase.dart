// lib/features/auth/domain/usecases/verify_otp_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUsecase {
  final AuthRepository _repository;

  const VerifyOtpUsecase(this._repository);

  /// Validates inputs, then calls verify-otp API.
  Future<Either<Failure, UserEntity>> call({
    required String phone,
    required String otp,
  }) async {
    if (otp.trim().length != 6) {
      return Left(ValidationFailure('OTP must be exactly 6 digits.'));
    }
    return _repository.verifyOtp(phone: phone.trim(), otp: otp.trim());
  }
}
