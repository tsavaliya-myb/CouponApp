import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';

// A simple class with equality or just a comma separated string.
final customerInfluencersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  final apiClient = GetIt.I<ApiClient>();
  final params = <String, String>{};
  if (query.isNotEmpty) {
    params['search'] = query;
  }
  final response = await apiClient.client.get('/influencers', queryParameters: params);
  return List<Map<String, dynamic>>.from(response.data['data']);
});

final influencerDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final apiClient = GetIt.I<ApiClient>();
  final response = await apiClient.client.get('/influencers/$id');
  return response.data['data'] as Map<String, dynamic>;
});

final bookInfluencerServiceProvider = StateNotifierProvider<BookServiceNotifier, AsyncValue<void>>((ref) {
  return BookServiceNotifier();
});

class BookServiceNotifier extends StateNotifier<AsyncValue<void>> {
  BookServiceNotifier() : super(const AsyncData(null));

  Future<bool> book(String serviceId, int expectedCoinsUsed, num expectedCoinCompensationAmt) async {
    state = const AsyncLoading();
    try {
      final apiClient = GetIt.I<ApiClient>();
      await apiClient.client.post('/influencers/services/$serviceId/book', data: {
        'expectedCoinsUsed': expectedCoinsUsed,
        'expectedCoinCompensationAmt': expectedCoinCompensationAmt,
      });
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final customerBookingsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiClient = GetIt.I<ApiClient>();
  final response = await apiClient.client.get('/influencers/me/bookings');
  return List<Map<String, dynamic>>.from(response.data['data']);
});
