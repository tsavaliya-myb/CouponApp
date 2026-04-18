// lib/core/providers/categories_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../models/category_item.dart';

/// Fetches the dynamic category list from GET /categories once per session.
final categoriesProvider = FutureProvider<List<CategoryItem>>((ref) async {
  final apiClient = GetIt.I<ApiClient>();
  final response = await apiClient.client.get('/categories');
  final List data = response.data['data'] as List;
  return data
      .map((e) => CategoryItem.fromJson(Map<String, dynamic>.from(e)))
      .toList();
});
