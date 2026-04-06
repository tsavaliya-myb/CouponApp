import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/seller_profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<SellerProfileModel> getSellerProfile();
  Future<SellerProfileModel> patchSellerProfile(
    UpdateSellerProfileParams params,
  );
}

@Injectable(as: ProfileRemoteDatasource)
class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final ApiClient _apiClient;

  ProfileRemoteDatasourceImpl(this._apiClient);

  @override
  Future<SellerProfileModel> getSellerProfile() async {
    final response = await _apiClient.client.get('/sellers/me');
    final responseModel = SellerProfileResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
    return responseModel.data;
  }

  @override
  Future<SellerProfileModel> patchSellerProfile(
    UpdateSellerProfileParams params,
  ) async {
    // Build only non-null fields so we send a true partial PATCH
    final body = <String, dynamic>{};
    if (params.upiId != null) body['upiId'] = params.upiId;
    if (params.latitude != null) body['latitude'] = params.latitude;
    if (params.longitude != null) body['longitude'] = params.longitude;

    final response = await _apiClient.client.patch('/sellers/me', data: body);
    final responseModel = SellerProfileResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
    return responseModel.data;
  }
}
