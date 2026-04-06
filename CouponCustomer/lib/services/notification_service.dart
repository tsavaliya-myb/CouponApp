// lib/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// OneSignal v5 push notification service.
///
/// Lifecycle:
///   1. [init]              → called in main() before runApp(). Initialises OneSignal.
///   2. [requestPermission] → called after login with a rationale bottom sheet.
///   3. [identifyUser]      → links device to backend userId after OTP success.
///   4. [setUserTags]       → sets segmentation tags after login.
///   5. [logout]            → dissociates device from user on sign-out.
///
/// Deep-link routing:
///   Backend sends `additional_data` with a `route` key (e.g. "/coupons").
///   The click listener navigates via [navigatorKey] wired into app.dart's GoRouter.
class NotificationService {
  final String _appId;
  final Logger _log = Logger();

  NotificationService(this._appId);

  // ---------------------------------------------------------------------------
  // Global navigator key — wire this into GoRouter in app.dart
  // ---------------------------------------------------------------------------

  /// Wire this into GoRouter:
  ///   final _router = GoRouter(navigatorKey: NotificationService.navigatorKey, ...);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

  // ---------------------------------------------------------------------------
  // Init — call before runApp()
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    // Enable verbose logging in debug builds only
    assert(() {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      return true;
    }());

    OneSignal.initialize(_appId);

    // Always display notification banners even when app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener(
      (OSNotificationWillDisplayEvent event) {
        _log.d('[OneSignal] Foreground notification: ${event.notification.title}');
        event.notification.display();
      },
    );

    // Handle notification tap → deep-link
    OneSignal.Notifications.addClickListener(
      (OSNotificationClickEvent event) {
        final data = event.notification.additionalData;
        _log.i('[OneSignal] Notification tapped. data=$data');
        _handleClick(data);
      },
    );

    _log.i('[NotificationService] OneSignal initialised. AppId=$_appId');
  }

  // ---------------------------------------------------------------------------
  // Permission request
  // ---------------------------------------------------------------------------

  /// Whether the user has already granted push notification permission.
  bool get hasPermission => OneSignal.Notifications.permission;

  /// Request OS-level push permission.
  /// Always show a rationale bottom sheet BEFORE calling this.
  Future<bool> requestPermission() async {
    final granted = await OneSignal.Notifications.requestPermission(true);
    _log.i('[NotificationService] Permission granted=$granted');
    return granted;
  }

  // ---------------------------------------------------------------------------
  // User identification
  // ---------------------------------------------------------------------------

  /// Link device to backend userId (call on login success).
  Future<void> identifyUser(String userId) async {
    await OneSignal.login(userId);
    _log.i('[NotificationService] identifyUser: $userId');
  }

  /// Dissociate device from user (call on logout).
  Future<void> logout() async {
    await OneSignal.logout();
    _log.i('[NotificationService] OneSignal user logged out');
  }

  // ---------------------------------------------------------------------------
  // Segmentation tags
  // ---------------------------------------------------------------------------

  /// Set tags for campaign targeting. Call after successful login.
  ///
  /// Recommended keys:
  ///   subscription_status  → "active" | "expired" | "none"
  ///   area                 → e.g. "Surat"
  ///   has_redeemed         → "true" | "false"
  ///   env                  → "dev" | "prod"
  Future<void> setUserTags(Map<String, String> tags) async {
    OneSignal.User.addTags(tags);
    _log.d('[NotificationService] Tags set: $tags');
  }

  // ---------------------------------------------------------------------------
  // Click handler — deep-links into app via GoRouter
  // ---------------------------------------------------------------------------

  /// Allowed routes from notification payloads.
  static const _allowedRoutes = {
    '/home',
    '/coupons',
    '/wallet',
    '/subscription',
    '/profile',
    '/sellers',
    '/qr',
  };

  void _handleClick(Map<String, dynamic>? data) {
    if (data == null) return;

    final route = data['route'] as String?;
    if (route == null || route.isEmpty) {
      _log.w('[NotificationService] No route in notification payload');
      return;
    }

    if (!_allowedRoutes.contains(route)) {
      _log.w('[NotificationService] Unknown route in payload: $route');
      return;
    }

    // Defer to next frame — notification click can fire before widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context == null) {
        _log.w('[NotificationService] Navigator context is null, cannot navigate');
        return;
      }
      _log.i('[NotificationService] Deep-linking to: $route');
      GoRouter.of(context).go(route);
    });
  }
}
