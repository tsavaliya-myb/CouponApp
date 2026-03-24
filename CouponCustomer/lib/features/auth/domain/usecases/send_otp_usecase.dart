// lib/features/auth/domain/usecases/send_otp_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendOtpUsecase {
  final AuthRepository _repository;

  const SendOtpUsecase(this._repository);

  /// Validates phone number, then dispatches to repository.
  Future<Either<Failure, String>> call({required String phone}) async {
    final trimmed = phone.trim();
    // Indian number: 10 digits, starts with 6-9
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(trimmed)) {
      return Left(ValidationFailure('Enter a valid 10-digit Indian mobile number.'));
    }
    return _repository.sendOtp(phone: trimmed);
  }
}
