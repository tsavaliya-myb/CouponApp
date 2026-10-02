import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';

final influencerDashboardNotifierProvider = StateNotifierProvider<InfluencerDashboardNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return InfluencerDashboardNotifier();
});

class InfluencerDashboardNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  InfluencerDashboardNotifier() : super(const AsyncLoading()) {
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    try {
      final apiClient = GetIt.I<ApiClient>();
      final response = await apiClient.client.get('/influencers/me/dashboard');
      state = AsyncData(response.data['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    await _fetchDashboard();
  }
}
