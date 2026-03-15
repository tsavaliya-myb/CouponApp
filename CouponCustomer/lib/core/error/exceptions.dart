// lib/core/error/exceptions.dart

/// Custom exception types thrown only by the data layer.
/// The domain/presentation layers never see these — only Failures.

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(code: $statusCode, msg: $message)';
}

class NetworkException implements Exception {
  const NetworkException();
  @override
  String toString() => 'NetworkException: No internet connection';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
  @override
  String toString() => 'UnauthorizedException: Token expired or invalid';
}

class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});
  @override
  String toString() => 'CacheException: $message';
}

class QrDecryptionException implements Exception {
  const QrDecryptionException();
  @override
  String toString() => 'QrDecryptionException: Failed to decrypt QR payload';
}
