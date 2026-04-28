// lib/features/home/domain/usecases/get_banner_ads_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/banner_ad_entity.dart';
import '../repositories/home_repository.dart';

@injectable
class GetBannerAdsUsecase {
  final HomeRepository _repo;
  GetBannerAdsUsecase(this._repo);

  Future<Either<Failure, List<BannerAdEntity>>> call({String? cityId}) =>
      _repo.getBannerAds(cityId: cityId);
}
