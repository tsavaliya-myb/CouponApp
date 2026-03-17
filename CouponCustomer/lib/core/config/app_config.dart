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

  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.razorpayKey,
    required this.qrSecretKey,
    required this.appVersion,
    required this.enableAnalytics,
    required this.enablePerformance,
  });

  static AppConfig? _instance;

  static AppConfig get current {
    assert(_instance != null, 'AppConfig.setup() must be called before accessing AppConfig.current');
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
      );
}
