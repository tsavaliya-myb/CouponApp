// lib/features/auth/presentation/screens/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isOtpComplete = _controllers.every((c) => c.text.isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'CouponCode Seller',
          style: AppTextStyles.headlineSM.copyWith(
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Shield Icon with Contextual Circles
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Text('OTP Verification', style: AppTextStyles.headlineMD),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the code sent to your registered phone number',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMD.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Phone Mask
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.phone.length >= 11
                          ? widget.phone.replaceRange(4, 11, ' .... ... ')
                          : widget.phone,
                      style: AppTextStyles.bodyMD.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // OTP Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 48),

              // Verify Button
              Consumer(
                builder: (context, ref, child) {
                  final authState = ref.watch(authNotifierProvider);
                  final isLoading = authState.isLoading;

                  return Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: (isOtpComplete && !isLoading)
                          ? AppColors.primaryGradient
                          : null,
                      color: (!isOtpComplete || isLoading)
                          ? AppColors.surfaceContainerHighest
                          : null,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: (isOtpComplete && !isLoading)
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: (isOtpComplete && !isLoading)
                          ? () async {
                              final otp = _controllers
                                  .map((c) => c.text)
                                  .join();
                              final authResult = await ref
                                  .read(authNotifierProvider.notifier)
                                  .verifyOtp(
                                    phone: widget.phone.replaceAll('+91', ''),
                                    otp: otp,
                                  );

                              if (context.mounted) {
                                if (authResult != null) {
                                  if (!authResult.isRegistered) {
                                    context.push(
                                      '/registration',
                                      extra: {
                                        'token': authResult.registrationToken,
                                        'phone': widget.phone,
                                      },
                                    );
                                  } else if (authResult.status == 'ACTIVE') {
                                    context.go('/dashboard');
                                  } else if (authResult.status == 'PENDING' ||
                                      authResult.status == 'REJECTED' ||
                                      authResult.status == 'SUSPENDED') {
                                    context.go('/approval-pending', extra: authResult.status);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Account status: ${authResult.status}',
                                        ),
                                      ),
                                    );
                                  }
                                } else if (authState.hasError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authState.error.toString()),
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Verify & Proceed',
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: isOtpComplete
                                        ? Colors.white
                                        : AppColors.textSecondary.withOpacity(
                                            0.5,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: isOtpComplete
                                      ? Colors.white
                                      : AppColors.textSecondary.withOpacity(
                                          0.5,
                                        ),
                                  size: 18,
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Resend Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: AppTextStyles.bodySM,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text('Resend OTP', style: AppTextStyles.footerLink),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'REQUEST NEW CODE IN 00:54',
                    style: AppTextStyles.labelSM.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Footer Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFooterAction(Icons.help_outline, 'HELP'),
                  _buildFooterAction(Icons.description_outlined, 'TERMS'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.headlineSM.copyWith(fontSize: 20),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: '●',
            hintStyle: TextStyle(
              color: AppColors.onSurface.withOpacity(0.2),
              fontSize: 10,
            ),
          ),
          onChanged: (value) => _onOtpChanged(index, value),
        ),
      ),
    );
  }

  Widget _buildFooterAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary.withOpacity(0.4), size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelSM.copyWith(
            color: AppColors.textSecondary.withOpacity(0.4),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
