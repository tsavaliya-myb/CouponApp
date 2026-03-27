import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../models/area_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUser();
  Future<UserModel> updateUser(Map<String, dynamic> data);
  Future<List<AreaModel>> getAreas(String cityId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> getUser() async {
    final response = await _apiClient.client.get('/users/me');
    print(response.data);
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> updateUser(Map<String, dynamic> data) async {
    final response = await _apiClient.client.patch('/users/me', data: data);
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<List<AreaModel>> getAreas(String cityId) async {
    final response = await _apiClient.client.get('/users/cities/$cityId/areas');
    final list = response.data['data'] as List;
    return list.map((e) => AreaModel.fromJson(e)).toList();
  }
}
