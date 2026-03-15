// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';

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
  initialLocation: '/',
  debugLogDiagnostics: true, // Disable in prod via --dart-define
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),
    // Screens will be added here screen by screen:
    // GoRoute(path: '/welcome',   name: 'welcome',   builder: ...)
    // GoRoute(path: '/otp',       name: 'otp',       builder: ...)
    // GoRoute(path: '/home',      name: 'home',      builder: ...)
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
