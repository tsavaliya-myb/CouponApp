// lib/features/home/domain/usecases/get_nearby_sellers_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/nearby_seller_entity.dart';
import '../repositories/home_repository.dart';

class GetNearbySellersUsecase {
  final HomeRepository _repository;

  GetNearbySellersUsecase(this._repository);

  Future<Either<Failure, List<NearbySellerEntity>>> call({
    required String areaId,
    String? categoryId,
    required int page,
  }) {
    return _repository.getNearbySellers(
      areaId: areaId,
      categoryId: categoryId,
      page: page,
    );
  }
}
