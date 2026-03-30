import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

@Injectable(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDatasource _remoteDatasource;

  HistoryRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, HistoryEntity>> getHistory({
    int page = 1,
    int limit = 20,
    String? period,
  }) async {
    try {
      final response = await _remoteDatasource.getHistory(
        page: page,
        limit: limit,
        period: period,
      );

      final redemptions = response.data.map((model) {
        return RedemptionEntity(
          id: model.id,
          userCouponId: model.userCouponId,
          sellerId: model.sellerId,
          userId: model.userId,
          billAmount: model.billAmount,
          discountAmount: model.discountAmount,
          coinsUsed: model.coinsUsed,
          finalAmount: model.finalAmount,
          redeemedAt: model.redeemedAt,
          userName: model.user?.name ?? 'Unknown User',
          userPhone: model.user?.phone ?? 'Unknown Phone',
          couponType: model.userCoupon?.coupon?.type ?? 'Unknown',
          couponDiscountPct: model.userCoupon?.coupon?.discountPct ?? 0.0,
          commissionAmt: model.settlementLine?.commissionAmt ?? 0.0,
          coinCompAmt: model.settlementLine?.coinCompAmt ?? 0.0,
        );
      }).toList();

      final entity = HistoryEntity(
        redemptions: redemptions,
        total: response.meta.total,
        page: response.meta.page,
        limit: response.meta.limit,
        totalPages: response.meta.totalPages,
      );

      return Right(entity);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message']));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
