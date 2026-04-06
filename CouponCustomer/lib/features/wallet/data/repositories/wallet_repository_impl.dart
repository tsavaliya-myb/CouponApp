import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, WalletEntity>> getWallet({int page = 1, int limit = 20}) async {
    try {
      final result = await _remoteDataSource.getWallet(page: page, limit: limit);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) return Left(e);
      return Left(const ServerFailure());
    }
  }
}
