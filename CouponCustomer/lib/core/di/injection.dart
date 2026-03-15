// lib/core/di/injection.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../network/retry_interceptor.dart';
import '../security/qr_token_service.dart';
import '../security/token_service.dart';
import '../storage/hive_service.dart';
import '../storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

/// Register all app-level dependencies.
/// Call this in main() before runApp().
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

  // ---------------------------------------------------------------------------
  // Network
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<RetryInterceptor>(() => RetryInterceptor());

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(getIt<TokenService>()),
  );

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      getIt<AuthInterceptor>(),
      getIt<RetryInterceptor>(),
    ),
  );
}
