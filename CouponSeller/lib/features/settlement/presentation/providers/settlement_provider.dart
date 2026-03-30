import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/usecases/get_settlements_usecase.dart';

part 'settlement_provider.g.dart';

@riverpod
class SettlementNotifier extends _$SettlementNotifier {
  late final GetSettlementsUsecase _getSettlementsUsecase;

  @override
  FutureOr<SettlementEntity> build() async {
    _getSettlementsUsecase = getIt<GetSettlementsUsecase>();
    return _fetchSettlements();
  }

  Future<SettlementEntity> _fetchSettlements() async {
    // Only need last 3 settlements, limited by the usecase
    final result = await _getSettlementsUsecase(page: 1, limit: 3);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (settlements) => settlements,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final settlements = await _fetchSettlements();
      state = AsyncData(settlements);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
