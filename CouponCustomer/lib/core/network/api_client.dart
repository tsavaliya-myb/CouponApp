// lib/core/network/api_client.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'retry_interceptor.dart';

/// Central Dio HTTP client with auth + retry interceptors.
/// All feature datasources inject this — never create their own Dio.
@singleton
class ApiClient {
  late final Dio _dio;

  ApiClient(
    AuthInterceptor authInterceptor,
    RetryInterceptor retryInterceptor,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.current.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Version': AppConfig.current.appVersion,
          'X-Platform': Platform.operatingSystem,
          'X-App-Type': 'customer',
        },
      ),
    );

    _dio.interceptors.addAll([
      authInterceptor,
      retryInterceptor,
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
      ),
    ]);
  }

  Dio get client => _dio;
}
