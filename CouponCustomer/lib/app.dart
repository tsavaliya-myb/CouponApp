// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_shell_scaffold.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/coupons/presentation/screens/my_coupons_screen.dart';
import 'features/coupons/presentation/screens/coupon_detail_screen.dart';
import 'features/qr/presentation/screens/qr_screen.dart';
import 'features/wallet/presentation/screens/wallet_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/account_settings_screen.dart';
import 'features/profile/presentation/screens/support_screen.dart';
import 'features/profile/presentation/screens/about_us_screen.dart';
import 'features/sellers/presentation/screens/sellers_screen.dart';
import 'features/sellers/presentation/screens/seller_detail_screen.dart';
import 'features/home/domain/entities/nearby_seller_entity.dart';
import 'features/home/domain/entities/home_coupon_entity.dart';
import 'features/wallet/presentation/screens/wallet_ledger_screen.dart';

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final _router = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true, // Disable in prod via --dart-define
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OtpScreen(phone: phone);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (_, __) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/coupons',
              name: 'coupons',
              builder: (_, __) => const MyCouponsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/qr',
              name: 'qr',
              builder: (_, __) => const QrScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sellers',
              name: 'sellers',
              builder: (_, __) => const SellersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wallet',
              name: 'wallet',
              builder: (_, __) => const WalletScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/seller-detail',
      name: 'seller-detail',
      builder: (context, state) {
        final seller = state.extra as NearbySellerEntity;
        return SellerDetailScreen(seller: seller);
      },
    ),
    GoRoute(
      path: '/coupon-detail',
      name: 'coupon-detail',
      builder: (context, state) {
        final coupon = state.extra as HomeCouponEntity;
        return CouponDetailScreen(coupon: coupon);
      },
    ),
    GoRoute(
      path: '/wallet-ledger',
      name: 'wallet-ledger',
      builder: (_, __) => const WalletLedgerScreen(),
    ),
    GoRoute(
      path: '/account-settings',
      name: 'account-settings',
      builder: (_, __) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/support',
      name: 'support',
      builder: (_, __) => const SupportScreen(),
    ),
    GoRoute(
      path: '/about-us',
      name: 'about-us',
      builder: (_, __) => const AboutUsScreen(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// Root App Widget
// ---------------------------------------------------------------------------

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'CouponApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
