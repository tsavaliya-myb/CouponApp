// lib/features/auth/presentation/screens/otp_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../features/profile/presentation/providers/profile_provider.dart';
import '../../../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../../../services/notification_service.dart';

// ─── State ───────────────────────────────────────────────────────────────────

enum _OtpStatus { idle, loading, error }

class _OtpState {
  final _OtpStatus status;
  final String? errorMessage;

  const _OtpState({this.status = _OtpStatus.idle, this.errorMessage});

  _OtpState copyWith({_OtpStatus? status, String? errorMessage}) => _OtpState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class _OtpNotifier extends StateNotifier<_OtpState> {
  final Logger _log = Logger();

  _OtpNotifier() : super(const _OtpState());

  Future<void> verifyOtp({
    required String phone,
    required String otp,
    required void Function() onSuccess,
    required void Function(String message) onError,
  }) async {
    state = state.copyWith(status: _OtpStatus.loading);
    final usecase = GetIt.I<VerifyOtpUsecase>();
    final result = await usecase(phone: phone, otp: otp);
    result.fold(
      (failure) {
        _log.w('VerifyOtp failed: ${failure.message}');
        state = state.copyWith(
          status: _OtpStatus.error,
          errorMessage: failure.message,
        );
        onError(failure.message);
      },
      (user) {
        _log.i('OTP verified for ${user.phone}');
        state = state.copyWith(status: _OtpStatus.idle);
        onSuccess();
      },
    );
  }

  Future<void> resendOtp({
    required String phone,
    required void Function(String message) onError,
  }) async {
    final usecase = GetIt.I<SendOtpUsecase>();
    final result = await usecase(phone: phone);
    result.fold(
      (failure) => onError(failure.message),
      (_) => _log.i('OTP resent to $phone'),
    );
  }
}

final _otpProvider = StateNotifierProvider.autoDispose<_OtpNotifier, _OtpState>(
  (_) => _OtpNotifier(),
);

// ─── Screen ──────────────────────────────────────────────────────────────────

class OtpScreen extends ConsumerStatefulWidget {
  /// Phone number passed from LoginScreen via GoRouter extra.
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final int _otpLength = 6;
  Timer? _resendTimer;
  int _resendSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
    _otpController.addListener(() {
      if (_otpController.text.length > _otpLength) {
        _otpController.text = _otpController.text.substring(0, _otpLength);
        _otpController.selection = TextSelection.collapsed(offset: _otpLength);
      }
      setState(() {});
    });
  }

  void _startTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleVerify() {
    ref.read(_otpProvider.notifier).verifyOtp(
          phone: widget.phone,
          otp: _otpController.text,
          onSuccess: () async {
            ref.read(authProvider.notifier).onLoginSuccess(phone: widget.phone);
            // Prefetch profile before navigating so isSubscribedProvider has
            // real data by the time gated screens render (avoids optimistic
            // loading:true flash showing premium content to non-subscribers).
            try {
              await ref.read(profileProvider.future);
            } catch (_) {
              // Network error — proceed anyway; screens will show error state
            }
            if (!mounted) return;
            await _requestNotificationPermission(context);
            if (mounted) context.go('/home');
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

  /// Shows a branded rationale bottom sheet, then triggers the OS permission
  /// prompt if the user accepts. Skips silently if already granted.
  Future<void> _requestNotificationPermission(BuildContext ctx) async {
    final notifService = GetIt.I<NotificationService>();

    // Check current state without triggering any OS dialog
    if (notifService.hasPermission) return;

    if (!ctx.mounted) return;

    final accepted = await showModalBottomSheet<bool>(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NotificationRationaleSheet(),
    );

    if (accepted == true && ctx.mounted) {
      await notifService.requestPermission();
    }
  }

  void _handleResend() {
    _startTimer();
    ref.read(_otpProvider.notifier).resendOtp(
          phone: widget.phone,
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
    final otpState = ref.watch(_otpProvider);
    final isLoading = otpState.status == _OtpStatus.loading;

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
                // Back button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.dsSurfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.dsOnSurface,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Top Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.dsSurfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dsOnSurface.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mark_email_unread_rounded,
                      color: AppColors.dsPrimary,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text('Check your\nmessages!', style: AppTextStyles.dsDisplayLg),
                const SizedBox(height: 16),

                // Show masked phone
                RichText(
                  text: TextSpan(
                    text: "We've sent a 6-digit code to ",
                    style: AppTextStyles.dsBodyMd.copyWith(
                      color: AppColors.dsOnSurface.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(
                        text: '+91 ${widget.phone}',
                        style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // VERIFICATION CODE Label
                Text(
                  'VERIFICATION CODE',
                  style: AppTextStyles.dsLabelMd.copyWith(
                    color: AppColors.dsPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Custom OTP Input
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_otpLength, (index) {
                        final text = _otpController.text;
                        final hasValue = index < text.length;
                        final isCurrentItem = index == text.length ||
                            (index == _otpLength - 1 &&
                                text.length == _otpLength);
                        final isActive = _isFocused && isCurrentItem;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.dsSurfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.dsPrimary.withOpacity(0.4)
                                  : hasValue
                                      ? AppColors.dsPrimary.withOpacity(0.1)
                                      : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              hasValue ? text[index] : '',
                              style: AppTextStyles.dsDisplayLg.copyWith(
                                fontSize: 24,
                                color: AppColors.dsOnSurface,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.0,
                        child: TextField(
                          controller: _otpController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: _otpLength,
                          autofocus: true,
                          decoration: const InputDecoration(
                            counterText: '',
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Resend
                Center(
                  child: _resendSeconds > 0
                      ? Text.rich(
                          TextSpan(
                            text: "Didn't receive it? ",
                            style: AppTextStyles.dsBodyMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.7),
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Resend in 00:${_resendSeconds.toString().padLeft(2, '0')}',
                                style: AppTextStyles.dsBodyMd.copyWith(
                                  color: AppColors.dsPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: _handleResend,
                          child: Text(
                            'Resend OTP',
                            style: AppTextStyles.dsBodyMd.copyWith(
                              color: AppColors.dsPrimary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 48),

                // Verify Button
                AnimatedOpacity(
                  opacity: isLoading ? 0.7 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
                      onPressed: (_otpController.text.length == _otpLength &&
                              !isLoading)
                          ? _handleVerify
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
                                Text(
                                  'Verify OTP',
                                  style: AppTextStyles.dsButton.copyWith(
                                    color:
                                        _otpController.text.length == _otpLength
                                            ? AppColors.dsSurfaceContainerLowest
                                            : AppColors.dsSurfaceContainerLowest
                                                .withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color:
                                      _otpController.text.length == _otpLength
                                          ? AppColors.dsSurfaceContainerLowest
                                          : AppColors.dsSurfaceContainerLowest
                                              .withOpacity(0.6),
                                  size: 20,
                                ),
                              ],
                            ),
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

// ─── Notification Rationale Bottom Sheet ─────────────────────────────────────

class _NotificationRationaleSheet extends StatelessWidget {
  const _NotificationRationaleSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dsSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dsOnSurface.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Bell icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.dsPrimary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.dsPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'Stay in the loop',
            style: AppTextStyles.dsTitleLg.copyWith(
              color: AppColors.dsOnSurface,
            ),
          ),
          const SizedBox(height: 10),

          // Body
          Text(
            'Get notified about coupon expirations, redemption\nconfirmations, and exclusive offers near you.',
            textAlign: TextAlign.center,
            style: AppTextStyles.dsBodyMd.copyWith(
              color: AppColors.dsOnSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Allow button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.dsPrimary, AppColors.dsPrimaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  'Allow Notifications',
                  style: AppTextStyles.dsButton.copyWith(
                    color: AppColors.dsSurfaceContainerLowest,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Skip
          GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Maybe later',
                style: AppTextStyles.dsBodyMd.copyWith(
                  color: AppColors.dsOnSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
