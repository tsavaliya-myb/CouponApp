// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/auth_provider.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_service.dart';
import 'services/notification_service.dart';

/// Development entry point.
/// Run with: flutter run -t lib/main.dart
/// Production: flutter run -t lib/main_prod.dart --dart-define=PAYU_KEY=xxx --dart-define=QR_SECRET_KEY=xxx
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Setup environment config
  AppConfig.setup(AppConfig.dev());

  // 2. Initialize GetIt DI
  await configureDependencies();

  // 3. Initialize Hive offline cache
  await getIt<HiveService>().init();

  // 4. Initialize OneSignal push notifications (must be before runApp)
  await getIt<NotificationService>().init();

  // 5. Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 8. Launch app inside ProviderScope (Riverpod root)
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
