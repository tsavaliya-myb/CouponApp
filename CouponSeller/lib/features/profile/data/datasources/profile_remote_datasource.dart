import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/seller_profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<SellerProfileModel> getSellerProfile();
  Future<SellerProfileModel> patchSellerProfile(
    UpdateSellerProfileParams params,
  );
  Future<void> uploadSellerLogo(String imagePath);
  Future<void> uploadSellerMedia({
    String? photo1Path,
    String? photo2Path,
    String? videoPath,
  });
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

  @override
  Future<void> uploadSellerLogo(String imagePath) async {
    final fileName = imagePath.split('/').last;
    final formData = FormData.fromMap({
      'logo': await MultipartFile.fromFile(imagePath, filename: fileName),
    });

    await _apiClient.client.post(
      '/sellers/me/logo',
      data: formData,
    );
  }

  @override
  Future<void> uploadSellerMedia({
    String? photo1Path,
    String? photo2Path,
    String? videoPath,
  }) async {
    final Map<String, dynamic> map = {};

    if (photo1Path != null) {
      map['photo1'] = await MultipartFile.fromFile(photo1Path,
          filename: photo1Path.split('/').last);
    }
    if (photo2Path != null) {
      map['photo2'] = await MultipartFile.fromFile(photo2Path,
          filename: photo2Path.split('/').last);
    }
    if (videoPath != null) {
      map['video'] = await MultipartFile.fromFile(videoPath,
          filename: videoPath.split('/').last);
    }

    final formData = FormData.fromMap(map);

    await _apiClient.client.post(
      '/sellers/me/media',
      data: formData,
    );
  }
}
