// lib/features/auth/domain/usecases/verify_otp_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../services/notification_service.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUsecase {
  final AuthRepository _repository;

  const VerifyOtpUsecase(this._repository);

  /// Validates inputs, calls verify-otp API, then on success:
  ///   1. Links this device to the backend userId in OneSignal.
  ///   2. Sets segmentation tags for targeted campaigns.
  Future<Either<Failure, UserEntity>> call({
    required String phone,
    required String otp,
  }) async {
    if (otp.trim().length != 6) {
      return Left(ValidationFailure('OTP must be exactly 6 digits.'));
    }

    final result = await _repository.verifyOtp(
      phone: phone.trim(),
      otp: otp.trim(),
    );

    // On success — identify user in OneSignal
    result.fold(
      (_) {}, // failure: nothing to do
      (user) async {
        final notifService = GetIt.I<NotificationService>();
        await notifService.identifyUser(user.id);
        await notifService.setUserTags({
          'subscription_status': 'none', // updated after subscription check
          'has_redeemed': 'false',
          'env': 'dev', // switch to 'prod' via dart-define if needed
          if (user.areaId != null) 'area': user.areaId!,
        });
      },
    );

    return result;
  }
}
