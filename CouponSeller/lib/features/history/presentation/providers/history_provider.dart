import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/history_entity.dart';
import '../../domain/usecases/get_history_usecase.dart';

part 'history_provider.g.dart';

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  late final GetHistoryUsecase _getHistoryUsecase;
  
  // Track parameters
  String _currentPeriod = 'this_week';
  int _currentPage = 1;
  static const int _limit = 20;
  
  // Track state
  HistoryEntity? _historyData;

  @override
  FutureOr<HistoryEntity> build() async {
    _getHistoryUsecase = getIt<GetHistoryUsecase>();
    return _fetchHistory(isRefresh: true);
  }

  Future<HistoryEntity> _fetchHistory({required bool isRefresh}) async {
    if (isRefresh) {
      _currentPage = 1;
    }

    final result = await _getHistoryUsecase(
      page: _currentPage,
      limit: _limit,
      period: _currentPeriod,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (history) {
        if (isRefresh) {
          _historyData = history;
        } else if (_historyData != null) {
          _historyData = HistoryEntity(
            redemptions: [..._historyData!.redemptions, ...history.redemptions],
            total: history.total,
            page: history.page,
            limit: history.limit,
            totalPages: history.totalPages,
          );
        } else {
          _historyData = history;
        }
        return _historyData!;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final history = await _fetchHistory(isRefresh: true);
      state = AsyncData(history);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.hasError || _historyData == null) return;
    
    if (_currentPage >= _historyData!.totalPages) return; // No more pages

    _currentPage++;
    // We don't set state to AsyncLoading() because we want to preserve current data
    // and show a bottom loader if needed.
    state = const AsyncLoading(); 
    try {
      final data = await _fetchHistory(isRefresh: false);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setPeriod(String period) async {
    if (_currentPeriod == period) return;
    _currentPeriod = period;
    
    state = const AsyncLoading();
    try {
      final history = await _fetchHistory(isRefresh: true);
      state = AsyncData(history);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
