class AppConfig {
  final String appName;
  final String baseUrl;
  final String qrSecretKey;
  final String appVersion;

  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.qrSecretKey,
    required this.appVersion,
  });

  static AppConfig get current => _instance!;
  static AppConfig? _instance;

  static void setup(AppConfig config) => _instance = config;

  factory AppConfig.prod() => const AppConfig(
    appName: 'Coupon Seller',
    baseUrl: String.fromEnvironment('BASE_URL'),
    qrSecretKey: String.fromEnvironment('QR_SECRET_KEY'),
    appVersion: '1.0.0',
  );

  /// Development flavor — points to local backend.
  /// Uses 10.0.2.2 for Android emulator to access host localhost.
  factory AppConfig.dev() => const AppConfig(
    appName: 'Coupon Seller (Dev)',
    baseUrl: 'https://couponapp-r1vv.onrender.com/api/v1',
    qrSecretKey: 'dev_qr_secret_key_32chars_padded!',
    appVersion: '1.0.0-dev',
  );
}
