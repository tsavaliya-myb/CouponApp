import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/history_entity.dart';
import '../repositories/history_repository.dart';

@injectable
class GetHistoryUsecase {
  final HistoryRepository repository;

  GetHistoryUsecase(this.repository);

  Future<Either<Failure, HistoryEntity>> call({
    int page = 1,
    int limit = 20,
    String? period,
  }) async {
    return await repository.getHistory(
      page: page,
      limit: limit,
      period: period,
    );
  }
}
