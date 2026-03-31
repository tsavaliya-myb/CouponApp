import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/verify_user_entity.dart';

abstract class RedemptionRepository {
  Future<Either<Failure, VerifyUserEntity>> verifyUser(String userId);
  
  Future<Either<Failure, bool>> confirmRedemption({
    required String userCouponId,
    required double billAmount,
    required double discountAmount,
    required double coinsUsed,
  });
}
