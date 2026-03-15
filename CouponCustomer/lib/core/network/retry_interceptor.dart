// lib/core/network/retry_interceptor.dart
import 'package:dio/dio.dart';

/// Automatically retries failed requests on 5xx errors with exponential backoff.
/// Max 3 retries — after that the error propagates.
class RetryInterceptor extends Interceptor {
  static const int _maxRetries = 3;
  static const List<int> _retryStatusCodes = [500, 502, 503, 504];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

    if (_shouldRetry(err) && retryCount < _maxRetries) {
      // Exponential backoff: 1s, 2s, 3s
      await Future.delayed(Duration(seconds: retryCount + 1));
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        final response = await Dio().fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        // Let it fall through to handler.next(err)
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) =>
      _retryStatusCodes.contains(err.response?.statusCode) ||
      err.type == DioExceptionType.connectionTimeout;
}
