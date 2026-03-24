import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

@module
abstract class RegisterModule {
  @singleton
  AppConfig get appConfig => AppConfig.current;

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @Named('refreshDio')
  @singleton
  Dio get refreshDio => Dio(BaseOptions(baseUrl: AppConfig.current.baseUrl));
}
