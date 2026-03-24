// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutUsecase {
  final AuthRepository _repository;

  const LogoutUsecase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.logout();
}
