import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletUseCase {
  final WalletRepository _repository;
  GetWalletUseCase(this._repository);

  Future<Either<Failure, WalletEntity>> call({int page = 1, int limit = 20}) {
    return _repository.getWallet(page: page, limit: limit);
  }
}
