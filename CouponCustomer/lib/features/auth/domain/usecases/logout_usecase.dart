// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../services/notification_service.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutUsecase {
  final AuthRepository _repository;

  const LogoutUsecase(this._repository);

  /// Logs out from the backend and dissociates this device from the
  /// OneSignal user so the device no longer receives targeted pushes.
  Future<Either<Failure, Unit>> call() async {
    final result = await _repository.logout();

    // Dissociate device from OneSignal user regardless of backend result
    await GetIt.I<NotificationService>().logout();

    return result;
  }
}
