import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../models/category_item.dart';

final categoriesProvider = FutureProvider<List<CategoryItem>>((ref) async {
  final apiClient = GetIt.I<ApiClient>();
  final response = await apiClient.client.get('/categories');
  return (response.data['data'] as List)
      .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
      .toList();
});
