import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/history_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, HistoryEntity>> getHistory({
    int page = 1,
    int limit = 20,
    String? period, // Optional: 'today', 'week', 'month' etc
  });
}
