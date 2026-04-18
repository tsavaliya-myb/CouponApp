// lib/features/home/data/datasources/home_remote_datasource.dart
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/home_coupon_model.dart';
import '../models/nearby_seller_model.dart';

abstract class HomeRemoteDatasource {
  /// Fetches ALL user coupons in one call (client-side category filtering).
  Future<List<HomeCouponModel>> getAllCoupons();

  Future<List<NearbySellerModel>> getNearbySellers({
    required String areaId,
    String? categoryId,
    required int page,
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
      queryParameters: {'page': 1, 'limit': 50},
    );
    final List data = response.data['data'] as List;
    return data
        .map((e) => HomeCouponModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<NearbySellerModel>> getNearbySellers({
    required String areaId,
    String? categoryId,
    required int page,
  }) async {
    final queryParams = <String, dynamic>{
      'areaId': areaId,
      'page': page,
      'limit': 20,
    };
    if (categoryId != null) {
      queryParams['categoryId'] = categoryId;
    }

    final response = await _apiClient.client.get(
      '/sellers/by-area-category',
      queryParameters: queryParams,
    );
    final List data = response.data['data'] as List;
    return data
        .map((e) => NearbySellerModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
