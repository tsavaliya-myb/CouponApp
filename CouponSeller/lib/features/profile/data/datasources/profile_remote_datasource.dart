import 'dart:io';
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

  // Bare Dio — no auth headers, hits iDrive E2 directly
  final Dio _s3Dio = Dio();

  ProfileRemoteDatasourceImpl(this._apiClient);

  // ─── Helpers ───────────────────────────────────────────────────────────────

  String _mimeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }

  /// Step 1: Ask API for a presigned PUT URL.
  Future<Map<String, dynamic>> _presign(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await _apiClient.client.post(endpoint, data: body);
    final data = (response.data as Map)['data'] as Map<String, dynamic>;
    return data;
  }

  /// Step 2: PUT file bytes directly to iDrive E2 (no auth headers).
  Future<void> _putToS3(
    String uploadUrl,
    String filePath,
    String mimeType,
  ) async {
    final bytes = await File(filePath).readAsBytes();
    await _s3Dio.put(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {'Content-Type': mimeType, 'Content-Length': bytes.length},
        sendTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 3),
      ),
    );
  }

  /// Step 3: Tell API to save the fileKey → public URL in DB.
  Future<void> _confirm(String endpoint, Map<String, dynamic> body) async {
    await _apiClient.client.post(endpoint, data: body);
  }

  // ─── API Methods ───────────────────────────────────────────────────────────

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
    final mimeType = _mimeFromPath(imagePath);

    // 1. Get presigned URL
    final presignData = await _presign('/sellers/me/logo/presign', {
      'mimeType': mimeType,
    });
    final uploadUrl = presignData['uploadUrl'] as String;
    final fileKey = presignData['fileKey'] as String;

    // 2. PUT file directly to iDrive E2
    await _putToS3(uploadUrl, imagePath, mimeType);

    // 3. Confirm with API — saves URL to DB
    await _confirm('/sellers/me/logo/confirm', {'fileKey': fileKey});
  }

  @override
  Future<void> uploadSellerMedia({
    String? photo1Path,
    String? photo2Path,
    String? videoPath,
  }) async {
    // 1. Build presign request body with only provided mime types
    final presignBody = <String, dynamic>{};
    if (photo1Path != null)
      presignBody['photo1MimeType'] = _mimeFromPath(photo1Path);
    if (photo2Path != null)
      presignBody['photo2MimeType'] = _mimeFromPath(photo2Path);
    if (videoPath != null)
      presignBody['videoMimeType'] = _mimeFromPath(videoPath);

    final presignData = await _presign(
      '/sellers/me/media/presign',
      presignBody,
    );

    // 2. PUT each file directly to iDrive E2 (in parallel for speed)
    final uploads = <Future<void>>[];

    if (photo1Path != null && presignData['photo1'] != null) {
      final d = presignData['photo1'] as Map<String, dynamic>;
      uploads.add(
        _putToS3(
          d['uploadUrl'] as String,
          photo1Path,
          _mimeFromPath(photo1Path),
        ),
      );
    }
    if (photo2Path != null && presignData['photo2'] != null) {
      final d = presignData['photo2'] as Map<String, dynamic>;
      uploads.add(
        _putToS3(
          d['uploadUrl'] as String,
          photo2Path,
          _mimeFromPath(photo2Path),
        ),
      );
    }
    if (videoPath != null && presignData['video'] != null) {
      final d = presignData['video'] as Map<String, dynamic>;
      uploads.add(
        _putToS3(d['uploadUrl'] as String, videoPath, _mimeFromPath(videoPath)),
      );
    }

    await Future.wait(uploads);

    // 3. Confirm — send fileKeys to save URLs in DB
    final confirmBody = <String, dynamic>{};
    if (photo1Path != null && presignData['photo1'] != null) {
      confirmBody['photo1Key'] = (presignData['photo1'] as Map)['fileKey'];
    }
    if (photo2Path != null && presignData['photo2'] != null) {
      confirmBody['photo2Key'] = (presignData['photo2'] as Map)['fileKey'];
    }
    if (videoPath != null && presignData['video'] != null) {
      confirmBody['videoKey'] = (presignData['video'] as Map)['fileKey'];
    }

    await _confirm('/sellers/me/media/confirm', confirmBody);
  }
}
