class AppConfig {
  final String appName;
  final String baseUrl;
  final String razorpayKey;
  final String appVersion;

  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.razorpayKey,
    required this.appVersion,
  });

  static AppConfig get current => _instance!;
  static AppConfig? _instance;

  static void setup(AppConfig config) => _instance = config;

  factory AppConfig.prod() => const AppConfig(
    appName: 'Coupon Seller',
    baseUrl: 'https://api.example.com/v1',
    razorpayKey: 'prod_key',
    appVersion: '1.0.0',
  );

  /// Development flavor — points to local backend.
  /// Uses 10.0.2.2 for Android emulator to access host localhost.
  factory AppConfig.dev() => const AppConfig(
    appName: 'Coupon Seller (Dev)',
    baseUrl: 'http://192.168.1.9:3000/api/v1',
    razorpayKey: 'rzp_test_placeholder',
    appVersion: '1.0.0-dev',
  );
}
