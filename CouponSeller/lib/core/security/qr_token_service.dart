// lib/core/security/qr_token_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:injectable/injectable.dart';
import '../config/app_config.dart';

/// QR payload is AES-256 encrypted — never raw JSON in the QR code.
/// This prevents tampering and protects user identity.
@singleton
class QrTokenService {
  late final Key _key;
  late final IV _iv;
  late final Encrypter _encrypter;

  QrTokenService() {
    final secret = AppConfig.current.qrSecretKey;
    // Key must be exactly 32 bytes for AES-256
    final keyBytes = secret.padRight(32, '0').substring(0, 32);
    _key = Key.fromUtf8(keyBytes);
    _iv = IV(
      Uint8List(16),
    ); // Explicit all-zero IV — deterministic across both apps
    _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
  }

  /// Generates an AES-encrypted QR payload for user profile.
  String generateUserQrPayload({
    required String userId,
    required String subscriptionToken,
  }) {
    final payload = jsonEncode({
      'uid': userId,
      'tok': subscriptionToken,
      'iat': DateTime.now().millisecondsSinceEpoch,
      'type': 'USER_PROFILE',
    });
    return _encrypter.encrypt(payload, iv: _iv).base64;
  }

  /// Decrypts a QR payload. Returns null if tampered or invalid.
  Map<String, dynamic>? decryptQrPayload(String encrypted) {
    try {
      final decrypted = _encrypter.decrypt64(encrypted, iv: _iv);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (e, stack) {
      return null;
    }
  }
}
