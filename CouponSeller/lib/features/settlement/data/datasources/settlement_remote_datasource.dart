import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/settlement_model.dart';


abstract class SettlementRemoteDatasource {
  Future<SettlementResponseModel> getSettlements({
    int page = 1,
    int limit = 20,
  });
}

@Injectable(as: SettlementRemoteDatasource)
class SettlementRemoteDatasourceImpl implements SettlementRemoteDatasource {
  final ApiClient _apiClient;

  SettlementRemoteDatasourceImpl(this._apiClient);

  @override
  Future<SettlementResponseModel> getSettlements({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.client.get(
      '/settlements',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return SettlementResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
