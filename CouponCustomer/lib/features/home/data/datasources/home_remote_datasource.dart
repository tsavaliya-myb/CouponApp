// lib/features/home/data/datasources/home_remote_datasource.dart
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/home_coupon_model.dart';
import '../models/nearby_seller_model.dart';

abstract class HomeRemoteDatasource {
  /// Fetches ALL user coupons in one call (client-side category filtering).
  Future<List<HomeCouponModel>> getAllCoupons();

  Future<List<NearbySellerModel>> getNearbySellers({
    required String cityId,
  });
}

@Injectable(as: HomeRemoteDatasource)
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final ApiClient _apiClient;

  HomeRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<HomeCouponModel>> getAllCoupons() async {
    final response = await _apiClient.client.get(
      '/coupons',
      queryParameters: {'page': 1, 'limit': 499},
    );
    final List data = response.data['data'] as List;
    return data
        .map((e) => HomeCouponModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<NearbySellerModel>> getNearbySellers({
    required String cityId,
  }) async {
    final response = await _apiClient.client.get(
      '/sellers/by-city-category',
      queryParameters: {'cityId': cityId, 'page': 1, 'limit': 499},
    );
    final List data = response.data['data'] as List;
    return data.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      final cat = map['category'];
      if (cat is Map) map['category'] = cat['slug'] as String;
      return NearbySellerModel.fromJson(map);
    }).toList();
  }
}
