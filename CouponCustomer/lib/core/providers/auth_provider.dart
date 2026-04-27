import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../error/failures.dart';
import '../security/token_service.dart';

// Provider for SharedPreferences instance (overridden in ProviderScope at main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in ProviderScope');
});

// ─── Auth State ───────────────────────────────────────────────────────────────

/// Holds the authenticated phone number, or null if not logged in.
/// Source of truth for GoRouter redirect guard.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final tokenService = GetIt.I<TokenService>();
  return AuthNotifier(tokenService, ref);
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
  final Ref _ref;

  AuthNotifier(this._tokenService, this._ref) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Checks secure storage for a valid token on app start.
  Future<void> _checkAuthStatus() async {
    final hasToken = await _tokenService.hasValidToken();

    if (hasToken) {
      try {
        final profileRepo = GetIt.I<ProfileRepository>();
        final response = await profileRepo.getUser();

        bool isUnauthorized = false;
        response.fold(
          (failure) {
            if (failure is UnauthorizedFailure) {
              isUnauthorized = true;
            }
          },
          (_) {},
        );

        if (isUnauthorized) {
          final usecase = GetIt.I<LogoutUsecase>();
          await usecase();
          state = state.copyWith(isAuthenticated: false, isLoading: false);
          return;
        }
      } catch (_) {
        // Network errors etc will fall through to here, let's keep them logged in
      }
    }

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
    _ref.invalidate(profileProvider);
    state = const AuthState(isLoading: false);
  }
}
