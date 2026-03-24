import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class RetryInterceptor extends Interceptor {
  static const int _maxRetries = 3;
  static const List<int> _retryStatusCodes = [500, 502, 503, 504];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
    if (_shouldRetry(err) && retryCount < _maxRetries) {
      await Future.delayed(Duration(seconds: retryCount + 1));
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {}
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) =>
      _retryStatusCodes.contains(err.response?.statusCode) ||
      err.type == DioExceptionType.connectionTimeout;
}
