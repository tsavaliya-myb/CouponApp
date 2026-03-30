import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/repositories/settlement_repository.dart';
import '../datasources/settlement_remote_datasource.dart';

@Injectable(as: SettlementRepository)
class SettlementRepositoryImpl implements SettlementRepository {
  final SettlementRemoteDatasource _remoteDatasource;

  SettlementRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, SettlementEntity>> getSettlements({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDatasource.getSettlements(
        page: page,
        limit: limit,
      );

      final items = response.data.map((model) {
        return SettlementItemEntity(
          id: model.id,
          sellerId: model.sellerId,
          weekStart: model.weekStart,
          weekEnd: model.weekEnd,
          commissionTotal: model.commissionTotal,
          commissionStatus: model.commissionStatus,
          commissionPaidAt: model.commissionPaidAt,
          coinCompensationTotal: model.coinCompensationTotal,
          coinCompStatus: model.coinCompStatus,
          coinCompPaidAt: model.coinCompPaidAt,
        );
      }).toList();

      final entity = SettlementEntity(
        items: items,
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
