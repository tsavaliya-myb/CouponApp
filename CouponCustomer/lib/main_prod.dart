// lib/main_prod.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_service.dart';
import 'services/notification_service.dart';

/// Production entry point.
/// Build with: flutter build apk -t lib/main_prod.dart --dart-define=RAZORPAY_KEY=rzp_live_xxx --dart-define=QR_SECRET_KEY=your_32_char_key
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.setup(AppConfig.prod());

  await configureDependencies();
  await getIt<HiveService>().init();
  await getIt<NotificationService>().init();

  runApp(const ProviderScope(child: App()));
}
