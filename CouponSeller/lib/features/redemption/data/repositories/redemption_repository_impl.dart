import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/verify_user_entity.dart';
import '../../domain/repositories/redemption_repository.dart';
import '../datasources/redemption_remote_datasource.dart';
import '../models/confirm_redemption_model.dart';

@Injectable(as: RedemptionRepository)
class RedemptionRepositoryImpl implements RedemptionRepository {
  final RedemptionRemoteDatasource _remoteDatasource;

  RedemptionRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, VerifyUserEntity>> verifyUser(String userId) async {
    try {
      final response = await _remoteDatasource.verifyUser(userId);
      final data = response.data;
      
      final entity = VerifyUserEntity(
        user: RedemptionUserEntity(
          id: data.user.id,
          name: data.user.name,
          phone: data.user.phone,
          hasActiveSubscription: data.user.hasActiveSubscription,
          availableCoins: data.user.availableCoins,
        ),
        eligibleCoupons: data.eligibleCoupons.map((c) => EligibleCouponEntity(
          id: c.id,
          couponBookId: c.couponBookId,
          couponId: c.couponId,
          usesRemaining: c.usesRemaining,
          status: c.status,
          coupon: RedemptionCouponEntity(
            id: c.coupon.id,
            sellerId: c.coupon.sellerId,
            discountPct: c.coupon.discountPct,
            adminCommissionPct: c.coupon.adminCommissionPct,
            minSpend: c.coupon.minSpend,
            maxUsesPerBook: c.coupon.maxUsesPerBook,
            type: c.coupon.type,
            status: c.coupon.status,
            isBaseCoupon: c.coupon.isBaseCoupon,
          ),
        )).toList(),
      );

      return Right(entity);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmRedemption({
    required String userCouponId,
    required double billAmount,
    required double discountAmount,
    required double coinsUsed,
  }) async {
    try {
      final request = ConfirmRedemptionRequestModel(
        userCouponId: userCouponId,
        billAmount: billAmount,
        discountAmount: discountAmount,
        coinsUsed: coinsUsed,
      );
      final response = await _remoteDatasource.confirmRedemption(request);
      return Right(response.success);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

