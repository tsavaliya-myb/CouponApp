// lib/features/home/data/datasources/home_remote_datasource.dart
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/home_coupon_model.dart';
import '../models/nearby_seller_model.dart';

abstract class HomeRemoteDatasource {
  Future<List<HomeCouponModel>> getFeaturedCoupons({
    required String category,
    required int page,
  });

  Future<List<NearbySellerModel>> getNearbySellers({required int page});
}

@Injectable(as: HomeRemoteDatasource)
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final ApiClient _apiClient;

  HomeRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<HomeCouponModel>> getFeaturedCoupons({
    required String category,
    required int page,
  }) async {
    final response = await _apiClient.client.get(
      '/coupons/featured',
      queryParameters: {'category': category, 'page': page, 'limit': 20},
    );
    final List data = response.data['data'] as List;
    return data
        .map((e) => HomeCouponModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<NearbySellerModel>> getNearbySellers({required int page}) async {
    final response = await _apiClient.client.get(
      '/sellers/nearby',
      queryParameters: {'page': page, 'limit': 20},
    );
    final List data = response.data['data'] as List;
    return data
        .map((e) => NearbySellerModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
