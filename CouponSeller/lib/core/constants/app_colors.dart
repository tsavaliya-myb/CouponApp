import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary & Secondary
  static const Color primary = Color(0xFF003461);
  static const Color primaryContainer = Color(0xFF004B87);
  static const Color secondary = Color(0xFF1B6D24);

  // Surface Hierarchy (Architecture)
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F9);
  static const Color surfaceContainerHigh = Color(0xFFEBEBEF);
  static const Color surfaceContainerHighest = Color(0xFFE3E3E9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFF9F9FF);

  // Functional
  static const Color onSurface = Color(0xFF191C20);
  static const Color outlineVariant = Color(0xFFC2C6D1);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Tokens for legacy/compatibility
  static const Color bgPage = surface;
  static const Color bgCard = surfaceContainerLowest;
  static const Color textPrimary = onSurface;
  static const Color textSecondary = Color(0xFF44474E);
  static const Color textOnDark = Colors.white;
  static const Color border = Color(0x26C2C6D1); // 15% opacity

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    transform: GradientRotation(135 * 3.14159 / 180),
  );
}
