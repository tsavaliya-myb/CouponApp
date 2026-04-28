// lib/features/home/data/repositories/home_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../../domain/entities/banner_ad_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

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
    required String cityId,
  }) async {
    try {
      final models = await _remote.getNearbySellers(cityId: cityId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (e, st) {
      debugPrint('getNearbySellers error: $e\n$st');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<BannerAdEntity>>> getBannerAds({
    String? cityId,
  }) async {
    try {
      final models = await _remote.getBannerAds(cityId: cityId);
      // BannerAdModel extends BannerAdEntity — no extra mapping needed
      return Right(models);
    } on DioException catch (e) {
      return Left(mapDioExceptionToFailure(e));
    } catch (e, st) {
      debugPrint('getBannerAds error: $e\n$st');
      return const Left(ServerFailure());
    }
  }
}
