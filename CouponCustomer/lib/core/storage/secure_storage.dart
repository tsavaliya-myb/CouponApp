// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Thin wrapper around FlutterSecureStorage.
/// All sensitive data (tokens, user ID) must go through this — never SharedPreferences.
@singleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  Future<String?> read({required String key}) =>
      _storage.read(key: key);

  Future<void> delete({required String key}) =>
      _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();

  Future<bool> containsKey({required String key}) =>
      _storage.containsKey(key: key);
}
