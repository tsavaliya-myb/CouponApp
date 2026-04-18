import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../../domain/entities/seller_entity.dart';

abstract class AuthRemoteDatasource {
  Future<SendOtpResponseModel> sendOtp({required String phone});
  Future<VerifyOtpResponseModel> verifyOtp({
    required String phone,
    required String otp,
  });
  Future<RegisterSellerResponseModel> registerSeller(
    RegisterSellerParams params,
  );
}

@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasourceImpl(this._apiClient);

  @override
  Future<SendOtpResponseModel> sendOtp({required String phone}) async {
    final response = await _apiClient.client.post(
      '/auth/seller/send-otp',
      data: {'phone': phone},
    );
    return SendOtpResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _apiClient.client.post(
      '/auth/seller/verify-otp',
      data: {'phone': phone, 'otp': otp},
    );
    return VerifyOtpResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<RegisterSellerResponseModel> registerSeller(
    RegisterSellerParams params,
  ) async {
    final response = await _apiClient.client.post(
      '/sellers/register',
      data: {
        "businessName": params.businessName,
        "categoryId": params.categoryId,
        "cityId": params.cityId,
        "areaId": params.areaId,
        "address": params.address,
        "email": params.email,
        "upiId": params.upiId,
        "lat": params.lat,
        "lng": params.lng,
      },
      options: Options(
        headers: {'Authorization': 'Bearer ${params.registrationToken}'},
      ),
    );
    return RegisterSellerResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
