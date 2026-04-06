import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/seller_profile_entity.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateSellerProfileUsecase {
  final ProfileRepository _repository;

  UpdateSellerProfileUsecase(this._repository);

  Future<Either<Failure, SellerProfileEntity>> call(
    UpdateSellerProfileParams params,
  ) {
    return _repository.updateSellerProfile(params);
  }
}
