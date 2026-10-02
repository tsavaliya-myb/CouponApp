import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../models/niche_item.dart';

final nichesProvider = FutureProvider<List<NicheItem>>((ref) async {
  final apiClient = GetIt.I<ApiClient>();
  // Public route for niches? In our API we added it under `/influencers/niches`
  final response = await apiClient.client.get('/influencers/niches');
  return (response.data['data'] as List)
      .map((e) => NicheItem.fromJson(e as Map<String, dynamic>))
      .toList();
});
