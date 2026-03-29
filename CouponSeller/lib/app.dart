// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/widgets/main_shell_scaffold.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/home/presentation/screens/dashboard_screen.dart';
import 'features/history/presentation/screens/history_screen.dart';
import 'features/settlement/presentation/screens/settlement_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/scan/presentation/screens/scan_screen.dart';
import 'features/redemption/presentation/screens/redemption_screen.dart';
import 'features/auth/presentation/screens/registration_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/registration',
        name: 'registration',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/redemption',
        name: 'redemption',
        builder: (context, state) {
          final qrData = state.extra as String? ?? '';
          return RedemptionScreen(qrData: qrData);
        },
      ),

      // Persistent Shell for Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Scan Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scan',
                name: 'scan',
                builder: (context, state) => const ScanScreen(),
              ),
            ],
          ),
          // History Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                name: 'history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          // Settlement Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settlement',
                name: 'settlement',
                builder: (context, state) => const SettlementScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class CouponSellerApp extends ConsumerWidget {
  const CouponSellerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'CouponCode Seller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF003461),
        fontFamily: 'Manrope',
      ),
      routerConfig: router,
    );
  }
}
