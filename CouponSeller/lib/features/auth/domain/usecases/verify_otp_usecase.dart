import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUsecase {
  final AuthRepository _repository;

  VerifyOtpUsecase(this._repository);

  Future<Either<Failure, AuthResultEntity>> call({
    required String phone,
    required String otp,
  }) async {
    if (otp.length != 6) {
      return Left(ValidationFailure('OTP must be 6 digits.'));
    }
    
    return _repository.verifyOtp(phone: phone, otp: otp);
  }
}
