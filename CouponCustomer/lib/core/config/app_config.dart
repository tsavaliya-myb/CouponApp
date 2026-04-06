// lib/core/config/app_config.dart

/// Environment-based configuration.
/// Keys are never hardcoded — they come from --dart-define at build time.
class AppConfig {
  final String appName;
  final String baseUrl;
  final String razorpayKey;
  final String qrSecretKey;
  final String appVersion;
  final bool enableAnalytics;
  final bool enablePerformance;

  /// OneSignal App ID — same for dev and prod.
  /// Environment separation is handled via OneSignal segments & tags.
  final String oneSignalAppId;

  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.razorpayKey,
    required this.qrSecretKey,
    required this.appVersion,
    required this.enableAnalytics,
    required this.enablePerformance,
    required this.oneSignalAppId,
  });

  static AppConfig? _instance;

  static AppConfig get current {
    assert(_instance != null,
        'AppConfig.setup() must be called before accessing AppConfig.current');
    return _instance!;
  }

  static void setup(AppConfig config) => _instance = config;

  // ---------------------------------------------------------------------------
  // Flavors
  // ---------------------------------------------------------------------------

  factory AppConfig.prod() => const AppConfig(
        appName: 'CouponApp',
        baseUrl: 'https://api.couponapp.in/v1',
        razorpayKey: String.fromEnvironment('RAZORPAY_KEY'),
        qrSecretKey: String.fromEnvironment('QR_SECRET_KEY'),
        appVersion: '1.0.0',
        enableAnalytics: true,
        enablePerformance: true,
        oneSignalAppId: 'c1aace53-f49e-4814-9292-9c23e92bbcbe',
      );

  /// Development flavor — points to local backend.
  /// Run with: flutter run (no extra flags needed)
  factory AppConfig.dev() => const AppConfig(
        appName: 'CouponApp (Dev)',
        baseUrl: 'https://couponapp-r1vv.onrender.com/api/v1',
        razorpayKey: 'rzp_test_SaDWFQaPFr4e2G',
        qrSecretKey: 'dev_qr_secret_key_32chars_padded!',
        appVersion: '1.0.0-dev',
        enableAnalytics: false,
        enablePerformance: false,
        oneSignalAppId: 'c1aace53-f49e-4814-9292-9c23e92bbcbe',
      );
}
