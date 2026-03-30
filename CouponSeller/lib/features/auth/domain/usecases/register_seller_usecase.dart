import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/seller_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterSellerUsecase {
  final AuthRepository _repository;

  RegisterSellerUsecase(this._repository);

  Future<Either<Failure, SellerEntity>> call(RegisterSellerParams params) async {
    // We could add domain validation here if needed
    return _repository.registerSeller(params);
  }
}
