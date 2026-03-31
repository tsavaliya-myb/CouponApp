import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/redemption_repository.dart';

@injectable
class ConfirmRedemptionUsecase {
  final RedemptionRepository _repository;

  ConfirmRedemptionUsecase(this._repository);

  Future<Either<Failure, bool>> call({
    required String userCouponId,
    required double billAmount,
    required double discountAmount,
    required double coinsUsed,
  }) {
    return _repository.confirmRedemption(
      userCouponId: userCouponId,
      billAmount: billAmount,
      discountAmount: discountAmount,
      coinsUsed: coinsUsed,
    );
  }
}
