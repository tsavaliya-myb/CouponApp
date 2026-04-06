// lib/core/constants/app_constants.dart

/// Global app-wide constants.
class AppConstants {
  AppConstants._();

  // Auth
  static const int otpLength          = 6;
  static const Duration otpTimeout    = Duration(minutes: 5);
  static const Duration otpResendDelay = Duration(seconds: 30);

  // API
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout    = Duration(seconds: 30);
  static const int maxRetries          = 3;
  static const int pageSize            = 20;

  // Subscription
  static const double subscriptionPrice = 1000.0;
  static const String subscriptionCurrency = 'INR';
  static const int couponBookDays = 45;

  // QR
  static const Duration qrRefreshInterval = Duration(minutes: 10);

  // Cache TTL
  static const Duration couponCacheTTL  = Duration(hours: 1);
  static const Duration sellerCacheTTL  = Duration(hours: 6);
  static const Duration profileCacheTTL = Duration(hours: 24);

  // Secure storage keys
  static const String accessTokenKey  = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey       = 'user_id';

  // Hive box names
  static const String couponBox   = 'coupons';
  static const String sellerBox   = 'sellers';
  static const String profileBox  = 'profile';
  static const String settingsBox = 'settings';

  // Pagination
  static const int nearbySellerRadius = 10; // km

  // Animation durations
  static const Duration animFast   = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow   = Duration(milliseconds: 600);

  // Add-on coupons
  static const int maxAddonCoupons = 5;
}
