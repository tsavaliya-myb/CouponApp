import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../redemption/domain/entities/verify_user_entity.dart';
import '../../../redemption/domain/usecases/verify_user_usecase.dart';

final scanProvider = StateNotifierProvider<ScanNotifier, AsyncValue<VerifyUserEntity?>>((ref) {
  return ScanNotifier(getIt<VerifyUserUsecase>());
});

class ScanNotifier extends StateNotifier<AsyncValue<VerifyUserEntity?>> {
  final VerifyUserUsecase _verifyUserUsecase;

  ScanNotifier(this._verifyUserUsecase) : super(const AsyncData(null));

  Future<void> verifyUser(String userId) async {
    state = const AsyncLoading();
    final result = await _verifyUserUsecase(userId);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (entity) => state = AsyncData(entity),
    );
  }

  void reset() {
    state = const AsyncData(null);
  }
}
