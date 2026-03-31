import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:injectable/injectable.dart';

@singleton
class QrTokenService {
  static const _secret = String.fromEnvironment(
    'QR_SECRET_KEY',
    defaultValue: 'dev_qr_secret_key_32chars_padded!',
  );

  static final _key = Key.fromUtf8(_secret.padRight(32, '0').substring(0, 32));
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  String _encrypt(String text) => _encrypter.encrypt(text, iv: _iv).base64;
  String _decrypt(String encrypted) => _encrypter.decrypt64(encrypted, iv: _iv);

  String generateUserQrPayload(String userId, String subscriptionToken) {
    final payload = jsonEncode({
      'uid': userId,
      'tok': subscriptionToken,
      'iat': DateTime.now().millisecondsSinceEpoch,
      'type': 'USER_PROFILE',
    });
    return _encrypt(payload);
  }

  Map<String, dynamic>? decryptQrPayload(String encrypted) {
    try {
      final decrypted = _decrypt(encrypted);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
