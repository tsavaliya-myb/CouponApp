// lib/core/error/error_handler.dart
import 'package:dio/dio.dart';
import 'failures.dart';

/// Maps low-level Dio exceptions to typed Failure objects.
/// Import this in repository implementations only.
Failure mapDioExceptionToFailure(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionError   => const NetworkFailure(),
    DioExceptionType.connectionTimeout => const NetworkFailure(),
    DioExceptionType.receiveTimeout    =>
        const ServerFailure(message: 'Request timed out. Please try again.'),
    DioExceptionType.sendTimeout       =>
        const ServerFailure(message: 'Request timed out. Please try again.'),
    _ => switch (e.response?.statusCode) {
      401 => const UnauthorizedFailure(),
      404 => NotFoundFailure(
          _extractMessage(e.response?.data) ?? 'Resource not found.',
        ),
      422 => ValidationFailure(
          _extractMessage(e.response?.data) ?? 'Validation error.',
        ),
      _   => ServerFailure(statusCode: e.response?.statusCode),
    }
  };
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data['message'] as String?;
  }
  return null;
}
