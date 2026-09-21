import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/redemption_history_entity.dart';

class RedemptionHistoryNotifier extends AutoDisposeAsyncNotifier<List<RedemptionHistoryEntity>> {
  @override
  Future<List<RedemptionHistoryEntity>> build() async {
    return fetchHistory('all');
  }

  Future<List<RedemptionHistoryEntity>> fetchHistory(String period) async {
    final apiClient = GetIt.I<ApiClient>();
    final response = await apiClient.client.get(
      '/redemptions/history',
      queryParameters: {'period': period, 'limit': 100},
    );
    
    final data = response.data['data'] as List;
    return data.map((e) => RedemptionHistoryEntity.fromJson(e)).toList();
  }

  Future<void> updatePeriod(String period) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchHistory(period));
  }
}

final redemptionHistoryProvider = AutoDisposeAsyncNotifierProvider<RedemptionHistoryNotifier, List<RedemptionHistoryEntity>>(
  RedemptionHistoryNotifier.new,
);

