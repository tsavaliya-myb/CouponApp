// lib/core/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../security/token_service.dart';

// Provider for SharedPreferences instance (overridden in ProviderScope at main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in ProviderScope');
});

// ─── Auth State ───────────────────────────────────────────────────────────────

/// Holds the authenticated phone number, or null if not logged in.
/// Source of truth for GoRouter redirect guard.
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final tokenService = GetIt.I<TokenService>();
  return AuthNotifier(tokenService);
});

class AuthState {
  final bool isAuthenticated;
  final String? phone;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.phone,
    this.isLoading = true, // true on first check
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? phone,
    bool? isLoading,
  }) =>
      AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        phone: phone ?? this.phone,
        isLoading: isLoading ?? this.isLoading,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenService _tokenService;

  AuthNotifier(this._tokenService) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Checks secure storage for a valid token on app start.
  Future<void> _checkAuthStatus() async {
    final hasToken = await _tokenService.hasValidToken();
    state = state.copyWith(isAuthenticated: hasToken, isLoading: false);
  }

  /// Called after successful OTP verification with the user's phone.
  void onLoginSuccess({required String phone}) {
    state = state.copyWith(
      isAuthenticated: true,
      phone: phone,
      isLoading: false,
    );
  }

  /// Clears tokens and resets auth state.
  Future<void> logout() async {
    final usecase = GetIt.I<LogoutUsecase>();
    await usecase();
    state = const AuthState(isLoading: false);
  }
}
