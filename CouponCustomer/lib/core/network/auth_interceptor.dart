// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../security/token_service.dart';

/// Attaches JWT Bearer token to every outgoing request.
/// On 401, attempts a silent token refresh before retrying.
/// On refresh failure, clears tokens and triggers re-login.
@injectable
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;
  final Dio _refreshDio; // Separate Dio instance — no interceptors (avoids loops)

  AuthInterceptor(this._tokenService)
      : _refreshDio = Dio(); // Plain Dio for refresh calls

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
        final response = await _refreshDio.fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        await _tokenService.clearTokens();
        // GoRouter redirect will handle re-login via auth state change
      }
    }
    handler.next(err);
  }
}
