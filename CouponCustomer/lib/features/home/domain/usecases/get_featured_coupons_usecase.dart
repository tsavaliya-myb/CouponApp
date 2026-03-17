// lib/features/home/domain/usecases/get_featured_coupons_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/home_coupon_entity.dart';
import '../repositories/home_repository.dart';

class GetFeaturedCouponsUsecase {
  final HomeRepository _repository;

  GetFeaturedCouponsUsecase(this._repository);

  Future<Either<Failure, List<HomeCouponEntity>>> call({
    required String category,
    required int page,
  }) {
    return _repository.getFeaturedCoupons(category: category, page: page);
  }
}
