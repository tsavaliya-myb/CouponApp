import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  late final GetDashboardUsecase _getDashboardUsecase;

  @override
  FutureOr<DashboardEntity> build() async {
    _getDashboardUsecase = getIt<GetDashboardUsecase>();
    return _fetchDashboard();
  }

  Future<DashboardEntity> _fetchDashboard() async {
    final result = await _getDashboardUsecase();

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (dashboard) {
        return dashboard;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final dashboard = await _fetchDashboard();
      state = AsyncData(dashboard);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
