// lib/features/home/domain/repositories/home_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/home_coupon_entity.dart';
import '../entities/nearby_seller_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeCouponEntity>>> getAllCoupons();

  Future<Either<Failure, List<NearbySellerEntity>>> getNearbySellers({
    required String cityId,
  });
}
