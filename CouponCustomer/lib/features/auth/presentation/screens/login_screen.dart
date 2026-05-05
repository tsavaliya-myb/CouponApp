// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../features/auth/domain/usecases/send_otp_usecase.dart';

// ─── State ───────────────────────────────────────────────────────────────────

enum _LoginStatus { idle, loading, error }

class _LoginState {
  final _LoginStatus status;
  final String? errorMessage;

  const _LoginState({this.status = _LoginStatus.idle, this.errorMessage});

  _LoginState copyWith({_LoginStatus? status, String? errorMessage}) =>
      _LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

// ─── Provider ────────────────────────────────────────────────────────────────

class _LoginNotifier extends StateNotifier<_LoginState> {
  final Logger _log = Logger();

  _LoginNotifier() : super(const _LoginState());

  Future<void> sendOtp({
    required String phone,
    required void Function(String phone) onSuccess,
    required void Function(String message) onError,
  }) async {
    state = state.copyWith(status: _LoginStatus.loading);
    final usecase = GetIt.I<SendOtpUsecase>();
    final result = await usecase(phone: phone);
    result.fold(
      (failure) {
        _log.w('SendOtp failed: ${failure.message}');
        state = state.copyWith(
          status: _LoginStatus.error,
          errorMessage: failure.message,
        );
        onError(failure.message);
      },
      (message) {
        _log.i('OTP sent to $phone: $message');
        state = state.copyWith(status: _LoginStatus.idle);
        onSuccess(phone);
      },
    );
  }
}

final _loginProvider =
    StateNotifierProvider.autoDispose<_LoginNotifier, _LoginState>(
  (_) => _LoginNotifier(),
);

// ─── Screen ──────────────────────────────────────────────────────────────────

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    ref.read(_loginProvider.notifier).sendOtp(
          phone: _phoneController.text.trim(),
          onSuccess: (phone) {
            context.push('/otp', extra: phone);
          },
          onError: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(_loginProvider);
    final isLoading = loginState.status == _LoginStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo
                Image.asset(
                  AppAssets.logo,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),

                Text('Welcome !', style: AppTextStyles.dsDisplayLg),
                const SizedBox(height: 16),

                Text(
                  'Enter your mobile number to\nstart exploring exclusive\nrewards.',
                  style: AppTextStyles.dsBodyMd.copyWith(
                    color: AppColors.dsOnSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 48),

                // MOBILE NUMBER Label
                Text(
                  'MOBILE NUMBER',
                  style: AppTextStyles.dsLabelMd.copyWith(
                    color: AppColors.dsPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Phone Input
                Row(
                  children: [
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.dsSurfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text('+91', style: AppTextStyles.dsTitleLg),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.dsOnSurface.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.dsSurfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isFocused
                                ? AppColors.dsPrimary.withOpacity(0.2)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _focusNode,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: AppTextStyles.dsTitleLg,
                            decoration: InputDecoration(
                              hintText: 'Enter phone number',
                              hintStyle: AppTextStyles.dsTitleLg.copyWith(
                                color: AppColors.dsOnSurface.withOpacity(0.3),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                              filled: false,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text.rich(
                  TextSpan(
                    text: "We'll send you a 6-digit code to verify your\nidentity.",
                    style: AppTextStyles.dsBodyMd.copyWith(
                      color: AppColors.dsOnSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Send OTP Button
                AnimatedOpacity(
                  opacity: isLoading ? 0.7 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.dsPrimary,
                          AppColors.dsPrimaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ElevatedButton(
                      onPressed: (_phoneController.text.trim().length == 10 &&
                              !isLoading)
                          ? _handleSendOtp
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor:
                            AppColors.dsPrimary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Send OTP',
                                    style: AppTextStyles.dsButton),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.dsSurfaceContainerLowest,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Terms of Service & Privacy Policy
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse('https://couponcode360.com');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to our ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[400],
                        ),
                        children: [
                          TextSpan(
                            text: 'terms of service & privacy policy',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[400],
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey[400],
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
