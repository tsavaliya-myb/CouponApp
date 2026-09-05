// lib/services/notification_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// ---------------------------------------------------------------------------
// Payment request data model — populated from OneSignal additional_data
// ---------------------------------------------------------------------------

class PaymentRequestData {
  final double finalAmount;
  final double discountAmount;
  final double billAmount;
  final String sellerName;
  final String redemptionId;

  const PaymentRequestData({
    required this.finalAmount,
    required this.discountAmount,
    required this.billAmount,
    required this.sellerName,
    required this.redemptionId,
  });

  factory PaymentRequestData.fromMap(Map<String, dynamic> data) {
    return PaymentRequestData(
      finalAmount: double.tryParse(data['finalAmount']?.toString() ?? '') ?? 0,
      discountAmount: double.tryParse(data['discountAmount']?.toString() ?? '') ?? 0,
      billAmount: double.tryParse(data['billAmount']?.toString() ?? '') ?? 0,
      sellerName: data['sellerName']?.toString() ?? 'Seller',
      redemptionId: data['redemptionId']?.toString() ?? '',
    );
  }
}

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
///
/// Payment popup:
///   Backend sends `additional_data` with `type: "payment_request"`.
///   Foreground: banner is suppressed, event emitted to [paymentRequestStream].
///   Background: notification click emits to [paymentRequestStream] for app.dart to handle.
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
  // Payment request stream — app.dart listens to show bottom sheet
  // ---------------------------------------------------------------------------

  static final StreamController<PaymentRequestData> paymentRequestStream =
      StreamController<PaymentRequestData>.broadcast();

  void _emitPaymentRequest(Map<String, dynamic> data) {
    try {
      final payload = PaymentRequestData.fromMap(data);
      paymentRequestStream.add(payload);
      _log.i('[NotificationService] PaymentRequest emitted: ₹${payload.finalAmount} at ${payload.sellerName}');
    } catch (e) {
      _log.e('[NotificationService] Failed to parse payment_request data', error: e);
    }
  }

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

    // Always display notification banners even when app is in foreground,
    // EXCEPT for payment_request type — those become in-app bottom sheets.
    OneSignal.Notifications.addForegroundWillDisplayListener(
      (OSNotificationWillDisplayEvent event) {
        final data = event.notification.additionalData;
        _log.d('[OneSignal] Foreground notification: ${event.notification.title}, data=$data');

        if (data != null && data['type'] == 'payment_request') {
          // Suppress the banner — show the in-app payment sheet instead
          event.preventDefault();
          _emitPaymentRequest(data);
        } else {
          event.notification.display();
        }
      },
    );

    // Handle notification tap → deep-link or payment popup
    OneSignal.Notifications.addClickListener(
      (OSNotificationClickEvent event) {
        final data = event.notification.additionalData;
        _log.i('[OneSignal] Notification tapped. data=$data');

        if (data != null && data['type'] == 'payment_request') {
          // App was backgrounded — emit so app.dart shows the bottom sheet
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _emitPaymentRequest(data);
          });
        } else {
          _handleClick(data);
        }
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

  /// Add SMS (phone number) identity for the user
  Future<void> setPhoneNumber(String phone) async {
    OneSignal.User.addSms(phone);
    _log.i('[NotificationService] Phone number added to OneSignal');
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


