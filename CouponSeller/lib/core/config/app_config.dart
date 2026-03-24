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
    baseUrl: 'https://api.example.com',
    razorpayKey: 'prod_key',
    appVersion: '1.0.0',
  );
}
