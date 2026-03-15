// lib/core/security/token_service.dart
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:coupon_customer/core/config/app_config.dart';

/// Manages JWT access/refresh tokens.
/// Tokens always live in encrypted secure storage — never SharedPreferences.
@singleton
class TokenService {
  final SecureStorageService _storage;

  TokenService(this._storage);

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.accessTokenKey, value: access),
      _storage.write(key: AppConstants.refreshTokenKey, value: refresh),
    ]);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: AppConstants.accessTokenKey);

  Future<String?> getRefreshToken() =>
      _storage.read(key: AppConstants.refreshTokenKey);

  Future<void> clearTokens() => _storage.deleteAll();

  Future<bool> hasValidToken() =>
      _storage.containsKey(key: AppConstants.accessTokenKey);

  /// Calls refresh endpoint and stores new tokens.
  /// Uses a plain Dio (no interceptors) to avoid recursive loops.
  Future<String> refreshToken(Dio plainDio) async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token stored');

    final response = await plainDio.post(
      '${AppConfig.current.baseUrl}/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    final newAccess  = response.data['access_token']  as String;
    final newRefresh = response.data['refresh_token'] as String;
    await saveTokens(access: newAccess, refresh: newRefresh);
    return newAccess;
  }
}
