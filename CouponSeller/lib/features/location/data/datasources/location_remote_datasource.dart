import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDatasource {
  Future<CityResponseModel> getCities();
  Future<AreaResponseModel> getAreas(String cityId);
}

@Injectable(as: LocationRemoteDatasource)
class LocationRemoteDatasourceImpl implements LocationRemoteDatasource {
  final ApiClient _apiClient;

  LocationRemoteDatasourceImpl(this._apiClient);

  @override
  Future<CityResponseModel> getCities() async {
    final response = await _apiClient.client.get('/admin/cities');
    return CityResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<AreaResponseModel> getAreas(String cityId) async {
    final response = await _apiClient.client.get('/admin/cities/$cityId/areas');
    return AreaResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
