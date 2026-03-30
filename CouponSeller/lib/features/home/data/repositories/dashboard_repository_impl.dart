import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

@Injectable(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource _remoteDatasource;

  DashboardRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard() async {
    try {
      final response = await _remoteDatasource.getDashboard();

      final data = response.data;
      final entity = DashboardEntity(
        totalRedemptions: data.totalRedemptions,
        status: data.status,
        commissionPct: data.commissionPct,
        todaysRedemptions: data.todaysRedemptions,
        thisWeekRedemptions: data.thisWeekRedemptions,
        commissionOwed: data.commissionOwed,
        coinReceivable: data.coinReceivable,
        businessName: data.businessName,
        city: data.city,
        recentRedemptions: data.recentRedemptions
            .map(
              (e) => RecentRedemptionEntity(
                id: e.id,
                couponName: e.couponName,
                amount: e.amount,
                createdAt: e.createdAt,
              ),
            )
            .toList(),
      );

      return Right(entity);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message']));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
