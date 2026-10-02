import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

final influencerServicesProvider = StateNotifierProvider<InfluencerServicesNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return InfluencerServicesNotifier();
});

class InfluencerServicesNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  InfluencerServicesNotifier() : super(const AsyncLoading()) {
    fetchServices();
  }

  Future<void> fetchServices() async {
    state = const AsyncLoading();
    try {
      final apiClient = GetIt.I<ApiClient>();
      final response = await apiClient.client.get('/influencers/me/services');
      state = AsyncData(List<Map<String, dynamic>>.from(response.data['data']));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> createService(Map<String, dynamic> data) async {
    try {
      final apiClient = GetIt.I<ApiClient>();
      await apiClient.client.post('/influencers/me/services', data: data);
      await fetchServices();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateService(String id, Map<String, dynamic> data) async {
    try {
      final apiClient = GetIt.I<ApiClient>();
      await apiClient.client.patch('/influencers/me/services/$id', data: data);
      await fetchServices();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleStatus(String id) async {
    try {
      final apiClient = GetIt.I<ApiClient>();
      await apiClient.client.post('/influencers/me/services/$id/toggle-status');
      await fetchServices();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> deleteService(String id) async {
    try {
      final apiClient = GetIt.I<ApiClient>();
      await apiClient.client.delete('/influencers/me/services/$id');
      await fetchServices();
      return null;
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['error'] ?? 'Failed to delete service';
      }
      return 'Failed to delete service';
    }
  }
}
