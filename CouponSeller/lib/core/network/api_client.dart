import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'retry_interceptor.dart';

@singleton
class ApiClient {
  late final Dio _dio;

  ApiClient(
    AppConfig config,
    AuthInterceptor authInterceptor,
    RetryInterceptor retryInterceptor,
  ) {
    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-App-Version': config.appVersion,
        'X-Platform': Platform.operatingSystem,
      },
    ));

    _dio.interceptors.addAll([
      authInterceptor,
      retryInterceptor,
      PrettyDioLogger(),
    ]);
  }

  Dio get client => _dio;
}
