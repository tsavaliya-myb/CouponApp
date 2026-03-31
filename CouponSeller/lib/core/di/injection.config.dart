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

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/register_seller_usecase.dart'
    as _i154;
import '../../features/auth/domain/usecases/send_otp_usecase.dart' as _i663;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/history/data/datasources/history_remote_datasource.dart'
    as _i1065;
import '../../features/history/data/repositories/history_repository_impl.dart'
    as _i751;
import '../../features/history/domain/repositories/history_repository.dart'
    as _i142;
import '../../features/history/domain/usecases/get_history_usecase.dart'
    as _i840;
import '../../features/home/data/datasources/dashboard_remote_datasource.dart'
    as _i840;
import '../../features/home/data/repositories/dashboard_repository_impl.dart'
    as _i1057;
import '../../features/home/domain/repositories/dashboard_repository.dart'
    as _i386;
import '../../features/home/domain/usecases/get_dashboard_usecase.dart'
    as _i814;
import '../../features/location/data/datasources/location_remote_datasource.dart'
    as _i700;
import '../../features/location/data/repositories/location_repository_impl.dart'
    as _i115;
import '../../features/location/domain/repositories/location_repository.dart'
    as _i332;
import '../../features/redemption/data/datasources/redemption_remote_datasource.dart'
    as _i733;
import '../../features/redemption/data/repositories/redemption_repository_impl.dart'
    as _i570;
import '../../features/redemption/domain/repositories/redemption_repository.dart'
    as _i955;
import '../../features/redemption/domain/usecases/confirm_redemption_usecase.dart'
    as _i1031;
import '../../features/redemption/domain/usecases/verify_user_usecase.dart'
    as _i854;
import '../../features/settlement/data/datasources/settlement_remote_datasource.dart'
    as _i448;
import '../../features/settlement/data/repositories/settlement_repository_impl.dart'
    as _i263;
import '../../features/settlement/domain/repositories/settlement_repository.dart'
    as _i586;
import '../../features/settlement/domain/usecases/get_settlements_usecase.dart'
    as _i610;
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
    gh.singleton<_i650.AppConfig>(() => registerModule.appConfig);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.singleton<_i10.RetryInterceptor>(() => _i10.RetryInterceptor());
    gh.singleton<_i660.QrTokenService>(() => _i660.QrTokenService());
    gh.singleton<_i459.HiveService>(() => _i459.HiveService());
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
    gh.factory<_i448.SettlementRemoteDatasource>(
      () => _i448.SettlementRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i586.SettlementRepository>(
      () => _i263.SettlementRepositoryImpl(
        gh<_i448.SettlementRemoteDatasource>(),
      ),
    );
    gh.factory<_i840.DashboardRemoteDatasource>(
      () => _i840.DashboardRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i161.AuthRemoteDatasource>(
      () => _i161.AuthRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i610.GetSettlementsUsecase>(
      () => _i610.GetSettlementsUsecase(gh<_i586.SettlementRepository>()),
    );
    gh.factory<_i386.DashboardRepository>(
      () =>
          _i1057.DashboardRepositoryImpl(gh<_i840.DashboardRemoteDatasource>()),
    );
    gh.factory<_i1065.HistoryRemoteDatasource>(
      () => _i1065.HistoryRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i700.LocationRemoteDatasource>(
      () => _i700.LocationRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i733.RedemptionRemoteDatasource>(
      () => _i733.RedemptionRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i332.LocationRepository>(
      () => _i115.LocationRepositoryImpl(gh<_i700.LocationRemoteDatasource>()),
    );
    gh.factory<_i142.HistoryRepository>(
      () => _i751.HistoryRepositoryImpl(gh<_i1065.HistoryRemoteDatasource>()),
    );
    gh.factory<_i955.RedemptionRepository>(
      () => _i570.RedemptionRepositoryImpl(
        gh<_i733.RedemptionRemoteDatasource>(),
      ),
    );
    gh.factory<_i814.GetDashboardUsecase>(
      () => _i814.GetDashboardUsecase(gh<_i386.DashboardRepository>()),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDatasource>(),
        gh<_i495.TokenService>(),
      ),
    );
    gh.factory<_i840.GetHistoryUsecase>(
      () => _i840.GetHistoryUsecase(gh<_i142.HistoryRepository>()),
    );
    gh.factory<_i663.SendOtpUsecase>(
      () => _i663.SendOtpUsecase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i503.VerifyOtpUsecase>(
      () => _i503.VerifyOtpUsecase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i154.RegisterSellerUsecase>(
      () => _i154.RegisterSellerUsecase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i854.VerifyUserUsecase>(
      () => _i854.VerifyUserUsecase(gh<_i955.RedemptionRepository>()),
    );
    gh.factory<_i1031.ConfirmRedemptionUsecase>(
      () => _i1031.ConfirmRedemptionUsecase(gh<_i955.RedemptionRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
