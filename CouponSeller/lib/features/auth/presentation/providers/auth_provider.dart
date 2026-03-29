import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final SendOtpUsecase _sendOtpUsecase;
  late final VerifyOtpUsecase _verifyOtpUsecase;

  @override
  FutureOr<void> build() {
    _sendOtpUsecase = getIt<SendOtpUsecase>();
    _verifyOtpUsecase = getIt<VerifyOtpUsecase>();
  }

  Future<bool> sendOtp(String phone) async {
    state = const AsyncLoading();
    final result = await _sendOtpUsecase(phone);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (successMessage) {
        state = const AsyncData(null);
        return true;
      },
    );
  }

  Future<AuthResultEntity?> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    state = const AsyncLoading();
    final result = await _verifyOtpUsecase(phone: phone, otp: otp);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return null;
      },
      (authResult) {
        state = const AsyncData(null);
        return authResult;
      },
    );
  }
}
