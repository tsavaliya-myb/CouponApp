import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/verify_user_entity.dart';
import '../repositories/redemption_repository.dart';

@injectable
class VerifyUserUsecase {
  final RedemptionRepository _repository;

  VerifyUserUsecase(this._repository);

  Future<Either<Failure, VerifyUserEntity>> call(String userId) {
    return _repository.verifyUser(userId);
  }
}
