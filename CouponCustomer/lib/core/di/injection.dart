// lib/core/di/injection.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../network/retry_interceptor.dart';
import '../security/qr_token_service.dart';
import '../security/token_service.dart';
import '../storage/hive_service.dart';
import '../storage/secure_storage.dart';
import '../../services/notification_service.dart';
// Auth feature
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
// Home feature
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_featured_coupons_usecase.dart';
import '../../features/home/domain/usecases/get_nearby_sellers_usecase.dart';
// Wallet feature
import '../../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/wallet/domain/usecases/get_wallet_usecase.dart';
// Profile feature
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ---------------------------------------------------------------------------
  // Third-party singletons
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // ---------------------------------------------------------------------------
  // Core services
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<TokenService>(
    () => TokenService(getIt<SecureStorageService>()),
  );
  getIt.registerLazySingleton<QrTokenService>(() => QrTokenService());
  getIt.registerLazySingleton<HiveService>(() => HiveService());
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(AppConfig.current.oneSignalAppId),
  );

  // ---------------------------------------------------------------------------
  // Network
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<RetryInterceptor>(() => RetryInterceptor());
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(getIt<TokenService>()),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<AuthInterceptor>(), getIt<RetryInterceptor>()),
  );

  // ---------------------------------------------------------------------------
  // Auth feature
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDatasource>(),
      getIt<TokenService>(),
    ),
  );
  getIt.registerFactory<SendOtpUsecase>(
    () => SendOtpUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<LogoutUsecase>(
    () => LogoutUsecase(getIt<AuthRepository>()),
  );

  // ---------------------------------------------------------------------------
  // Home feature
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDatasource>()),
  );
  getIt.registerFactory<GetFeaturedCouponsUsecase>(
    () => GetFeaturedCouponsUsecase(getIt<HomeRepository>()),
  );
  getIt.registerFactory<GetNearbySellersUsecase>(
    () => GetNearbySellersUsecase(getIt<HomeRepository>()),
  );

  // ---------------------------------------------------------------------------
  // Wallet feature
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(getIt<WalletRemoteDataSource>()),
  );
  getIt.registerFactory<GetWalletUseCase>(
    () => GetWalletUseCase(getIt<WalletRepository>()),
  );

  // ---------------------------------------------------------------------------
  // Profile feature
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
}

