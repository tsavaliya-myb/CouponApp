// lib/features/home/data/repositories/home_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/nearby_seller_model.dart';
import '../models/home_coupon_model.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _remote;

  HomeRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<HomeCouponEntity>>> getAllCoupons() async {
    try {
      final models = await _remote.getAllCoupons();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<NearbySellerEntity>>> getNearbySellers({
    required String areaId,
    String? categoryId,
    required int page,
  }) async {
    try {
      final models = await _remote.getNearbySellers(
        areaId: areaId,
        categoryId: categoryId,
        page: page,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
