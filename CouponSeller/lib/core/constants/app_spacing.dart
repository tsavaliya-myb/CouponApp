// lib/core/constants/app_spacing.dart

/// Spacing tokens — use these throughout the app for consistent layout.
/// Never use raw double literals; always refer to AppSpacing.
class AppSpacing {
  AppSpacing._();

  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;

  // Screen horizontal padding
  static const double screenPadding = 20.0;

  // Radius
  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 16.0;
  static const double radiusXl  = 20.0;
  static const double radiusFull = 100.0;

  // Icon sizes
  static const double iconSm  = 16.0;
  static const double iconMd  = 20.0;
  static const double iconLg  = 24.0;
  static const double iconXl  = 32.0;
  static const double iconXxl = 48.0;

  // Button
  static const double buttonHeight    = 52.0;
  static const double buttonHeightSm  = 40.0;

  // Card
  static const double cardPadding     = 16.0;
  static const double cardRadius      = 16.0;
  static const double cardElevation   = 0.0; // We use borders instead of elevation

  // Bottom Nav
  static const double bottomNavHeight = 70.0;
}
