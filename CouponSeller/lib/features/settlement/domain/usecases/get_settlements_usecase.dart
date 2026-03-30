import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/settlement_entity.dart';
import '../repositories/settlement_repository.dart';

@injectable
class GetSettlementsUsecase {
  final SettlementRepository repository;

  GetSettlementsUsecase(this.repository);

  Future<Either<Failure, SettlementEntity>> call({
    int page = 1,
    int limit = 3, // Requirements: show last 3 settlements
  }) async {
    return await repository.getSettlements(
      page: page,
      limit: limit,
    );
  }
}
