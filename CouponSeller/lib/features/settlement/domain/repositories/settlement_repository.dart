import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/settlement_entity.dart';

abstract class SettlementRepository {
  Future<Either<Failure, SettlementEntity>> getSettlements({
    int page = 1,
    int limit = 20,
  });
}
