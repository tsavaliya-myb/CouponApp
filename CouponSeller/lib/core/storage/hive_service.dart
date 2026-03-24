import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveService {
  static const Duration couponCacheTTL  = Duration(hours: 1);
  static const Duration sellerCacheTTL  = Duration(hours: 6);
  static const Duration profileCacheTTL = Duration(hours: 24);

  Future<void> init() async {
    await Hive.initFlutter();
  }
}
