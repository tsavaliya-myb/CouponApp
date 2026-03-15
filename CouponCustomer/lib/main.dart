// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_service.dart';
import 'services/notification_service.dart';

/// Development entry point.
/// Run with: flutter run -t lib/main.dart
/// Production: flutter run -t lib/main_prod.dart --dart-define=RAZORPAY_KEY=xxx --dart-define=QR_SECRET_KEY=xxx
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Setup environment config (dev flavor)
  AppConfig.setup(AppConfig.dev());

  // 2. Firebase removed

  // 3. Initialize GetIt DI
  await configureDependencies();

  // 4. Initialize Hive offline cache
  await getIt<HiveService>().init();


  // 6. Initialize Push Notifications
  await getIt<NotificationService>().init();

  // 7. Launch app inside ProviderScope (Riverpod root)
  runApp(const ProviderScope(child: App()));
}
