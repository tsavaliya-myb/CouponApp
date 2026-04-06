import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/seller_profile_entity.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetSellerProfileUsecase {
  final ProfileRepository _repository;

  GetSellerProfileUsecase(this._repository);

  Future<Either<Failure, SellerProfileEntity>> call() {
    return _repository.getSellerProfile();
  }
}
