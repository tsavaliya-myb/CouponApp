// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<SendOtpResponseModel> sendOtp({required String phone});
  Future<VerifyOtpResponseModel> verifyOtp({
    required String phone,
    required String otp,
  });
}

@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasourceImpl(this._apiClient);

  @override
  Future<SendOtpResponseModel> sendOtp({required String phone}) async {
    final response = await _apiClient.client.post(
      '/auth/send-otp',
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
      '/auth/verify-otp',
      data: {'phone': phone, 'otp': otp},
    );
    return VerifyOtpResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
