import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Single environment setup
  AppConfig.setup(AppConfig.prod()); 
  
  // Init DI
  configureDependencies();

  runApp(const ProviderScope(child: App()));
}
