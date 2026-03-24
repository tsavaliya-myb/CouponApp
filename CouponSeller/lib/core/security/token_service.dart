import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@singleton
class TokenService {
  final FlutterSecureStorage _storage;
  static const _accessKey  = 'access_token';
  static const _refreshKey = 'refresh_token';

  TokenService(this._storage);

  Future<void> saveTokens({required String access, required String refresh}) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  Future<String?> getAccessToken()  => _storage.read(key: _accessKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);
  Future<void>    clearTokens()     => _storage.deleteAll();
  
  Future<String> refreshToken(Dio refreshDio) async {
    final refresh = await getRefreshToken();
    if (refresh == null) throw Exception('No refresh token');
    
    final response = await refreshDio.post('/auth/refresh', data: {
      'refreshToken': refresh,
    });
    
    final newAccess = response.data['accessToken'];
    final newRefresh = response.data['refreshToken'];
    await saveTokens(access: newAccess, refresh: newRefresh);
    return newAccess;
  }
}
