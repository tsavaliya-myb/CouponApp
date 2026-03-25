import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet({int page = 1, int limit = 20});
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSourceImpl(this._apiClient);

  @override
  Future<WalletModel> getWallet({int page = 1, int limit = 20}) async {
    final response = await _apiClient.client.get(
      '/wallet',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = Map<String, dynamic>.from(response.data as Map);
    return WalletModel.fromJson(data['data'] as Map<String, dynamic>);
  }
}
