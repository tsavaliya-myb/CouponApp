import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for a simulated splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Wait for TokenService to finish checking secure storage
    AuthState authState = ref.read(authProvider);
    while (authState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      authState = ref.read(authProvider);
    }

    if (!mounted) return;
    if (authState.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurfaceContainerLowest,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.dsPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.celebration_rounded,
                  color: AppColors.dsPrimary,
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'CouponBook',
              style: AppTextStyles.dsDisplayLg.copyWith(
                color: AppColors.dsPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.dsPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
