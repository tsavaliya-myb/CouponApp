import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../security/token_service.dart';

@singleton
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;
  final Dio _refreshDio;

  AuthInterceptor(this._tokenService, @Named('refreshDio') this._refreshDio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _tokenService.refreshToken(_refreshDio);
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await _refreshDio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        await _tokenService.clearTokens();
        // TODO: AppRouter.navigateToLogin();
      }
    }
    handler.next(err);
  }
}
