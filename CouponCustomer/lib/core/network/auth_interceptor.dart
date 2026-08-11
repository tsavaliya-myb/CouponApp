// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../security/session_manager.dart';
import '../security/token_service.dart';

/// Attaches JWT Bearer token to every outgoing request.
/// On 401, attempts a silent token refresh before retrying.
/// On refresh failure, clears tokens and signals SessionManager so AuthNotifier
/// can wipe cached state and redirect to login.
@injectable
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;
  final SessionManager _sessionManager;
  final Dio _refreshDio; // Separate Dio instance — no interceptors (avoids loops)

  AuthInterceptor(this._tokenService, this._sessionManager)
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
        // Session is unrecoverable — AuthNotifier listens and does the rest
        // (cache wipe, provider invalidation, GoRouter redirect to login).
        _sessionManager.expire();
      }
    }
    handler.next(err);
  }
}
