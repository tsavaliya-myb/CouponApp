import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/confirm_redemption_usecase.dart';

final redemptionProvider = StateNotifierProvider<RedemptionNotifier, AsyncValue<bool?>>((ref) {
  return RedemptionNotifier(getIt<ConfirmRedemptionUsecase>());
});

class RedemptionNotifier extends StateNotifier<AsyncValue<bool?>> {
  final ConfirmRedemptionUsecase _confirmRedemptionUsecase;

  RedemptionNotifier(this._confirmRedemptionUsecase) : super(const AsyncData(null));

  Future<void> confirmRedemption({
    required String userCouponId,
    required double billAmount,
    required double discountAmount,
    required double coinsUsed,
  }) async {
    state = const AsyncLoading();
    final result = await _confirmRedemptionUsecase(
      userCouponId: userCouponId,
      billAmount: billAmount,
      discountAmount: discountAmount,
      coinsUsed: coinsUsed,
    );
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (success) => state = const AsyncData(true),
    );
  }

  void reset() {
    state = const AsyncData(null);
  }
}
