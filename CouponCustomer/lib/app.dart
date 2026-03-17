// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

// ---------------------------------------------------------------------------
// Placeholder screens — will be replaced screen by screen
// ---------------------------------------------------------------------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final _router = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true, // Disable in prod via --dart-define
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (_, __) => const HomeScreen(),
    ),
    // Screens will be added here screen by screen:
    // GoRoute(path: '/welcome',   name: 'welcome',   builder: ...)
    // GoRoute(path: '/otp',       name: 'otp',       builder: ...)
    // GoRoute(path: '/coupons',   name: 'coupons',   builder: ...)
    // GoRoute(path: '/profile',   name: 'profile',   builder: ...)
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
