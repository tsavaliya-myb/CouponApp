import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/history_model.dart';

abstract class HistoryRemoteDatasource {
  Future<HistoryResponseModel> getHistory({
    int page = 1,
    int limit = 20,
    String? period, // Optional: 'today', 'week', 'month' etc
  });
}

@Injectable(as: HistoryRemoteDatasource)
class HistoryRemoteDatasourceImpl implements HistoryRemoteDatasource {
  final ApiClient _apiClient;

  HistoryRemoteDatasourceImpl(this._apiClient);

  @override
  Future<HistoryResponseModel> getHistory({
    int page = 1,
    int limit = 20,
    String? period,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };
    if (period != null) {
      queryParams['period'] = period;
    }

    final response = await _apiClient.client.get(
      '/redemptions/seller/history',
      queryParameters: queryParams,
    );

    return HistoryResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
