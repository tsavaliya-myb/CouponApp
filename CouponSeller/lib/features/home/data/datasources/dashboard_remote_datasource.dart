import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRemoteDatasource {
  Future<DashboardResponseModel> getDashboard();
}

@Injectable(as: DashboardRemoteDatasource)
class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final ApiClient _apiClient;

  DashboardRemoteDatasourceImpl(this._apiClient);

  @override
  Future<DashboardResponseModel> getDashboard() async {
    final response = await _apiClient.client.get('/sellers/me/dashboard');
    return DashboardResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
