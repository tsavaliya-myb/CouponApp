import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

@injectable
class GetDashboardUsecase {
  final DashboardRepository repository;

  GetDashboardUsecase(this.repository);

  Future<Either<Failure, DashboardEntity>> call() async {
    return await repository.getDashboard();
  }
}
