import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendOtpUsecase {
  final AuthRepository _repository;

  SendOtpUsecase(this._repository);

  Future<Either<Failure, String>> call(String phone) async {
    // Standard Indian phone number validation
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      return Left(ValidationFailure('Please enter a valid 10-digit phone number.'));
    }
    
    return _repository.sendOtp(phone: phone);
  }
}
