import 'package:dio/dio.dart';
import 'failures.dart';

Failure mapDioExceptionToFailure(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionError    => const NetworkFailure(),
    DioExceptionType.connectionTimeout  => const NetworkFailure(),
    DioExceptionType.receiveTimeout     => const ServerFailure(message: 'Request timed out.'),
    _ => switch (e.response?.statusCode) {
      401 => const UnauthorizedFailure(),
      404 => NotFoundFailure(e.response?.data['message'] ?? 'Not found'),
      422 => ValidationFailure(e.response?.data['message'] ?? 'Validation error'),
      _   => ServerFailure(statusCode: e.response?.statusCode),
    }
  };
}
