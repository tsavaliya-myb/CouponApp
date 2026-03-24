// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../config/app_config.dart' as _i650;
import '../network/api_client.dart' as _i557;
import '../network/auth_interceptor.dart' as _i908;
import '../network/retry_interceptor.dart' as _i10;
import '../security/qr_token_service.dart' as _i660;
import '../security/token_service.dart' as _i495;
import '../storage/hive_service.dart' as _i459;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i10.RetryInterceptor>(() => _i10.RetryInterceptor());
    gh.singleton<_i660.QrTokenService>(() => _i660.QrTokenService());
    gh.singleton<_i459.HiveService>(() => _i459.HiveService());
    gh.singleton<_i650.AppConfig>(() => registerModule.appConfig);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.singleton<_i361.Dio>(
      () => registerModule.refreshDio,
      instanceName: 'refreshDio',
    );
    gh.singleton<_i495.TokenService>(
      () => _i495.TokenService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(
        gh<_i495.TokenService>(),
        gh<_i361.Dio>(instanceName: 'refreshDio'),
      ),
    );
    gh.singleton<_i557.ApiClient>(
      () => _i557.ApiClient(
        gh<_i650.AppConfig>(),
        gh<_i908.AuthInterceptor>(),
        gh<_i10.RetryInterceptor>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
