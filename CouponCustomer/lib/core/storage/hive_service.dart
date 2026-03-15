// lib/core/storage/hive_service.dart
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';

/// Manages offline cache using Hive with TTL-based invalidation.
@singleton
class HiveService {
  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    await Hive.initFlutter();
    // Open all boxes eagerly on app start
    await Future.wait([
      Hive.openBox<dynamic>(AppConstants.couponBox),
      Hive.openBox<dynamic>(AppConstants.sellerBox),
      Hive.openBox<dynamic>(AppConstants.profileBox),
      Hive.openBox<dynamic>(AppConstants.settingsBox),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Generic cache helpers
  // ---------------------------------------------------------------------------

  Future<void> _put(String boxName, String key, dynamic value) async {
    final box = Hive.box<dynamic>(boxName);
    await box.put(key, value);
    await box.put('${key}_cachedAt', DateTime.now().toIso8601String());
  }

  dynamic _get(String boxName, String key, Duration ttl) {
    final box = Hive.box<dynamic>(boxName);
    final cachedAt = box.get('${key}_cachedAt') as String?;
    if (cachedAt == null) return null;
    final age = DateTime.now().difference(DateTime.parse(cachedAt));
    if (age > ttl) return null; // Stale — force refresh
    return box.get(key);
  }

  Future<void> _delete(String boxName, String key) async {
    final box = Hive.box<dynamic>(boxName);
    await box.delete(key);
    await box.delete('${key}_cachedAt');
  }

  // ---------------------------------------------------------------------------
  // Coupon cache
  // ---------------------------------------------------------------------------

  Future<void> cacheCoupons(List<Map<String, dynamic>> coupons) =>
      _put(AppConstants.couponBox, 'data', jsonEncode(coupons));

  List<Map<String, dynamic>>? getCachedCoupons() {
    final raw = _get(AppConstants.couponBox, 'data', AppConstants.couponCacheTTL);
    if (raw == null) return null;
    return (jsonDecode(raw as String) as List)
        .cast<Map<String, dynamic>>();
  }

  Future<void> clearCouponCache() => _delete(AppConstants.couponBox, 'data');

  // ---------------------------------------------------------------------------
  // Seller cache
  // ---------------------------------------------------------------------------

  Future<void> cacheSellers(List<Map<String, dynamic>> sellers) =>
      _put(AppConstants.sellerBox, 'data', jsonEncode(sellers));

  List<Map<String, dynamic>>? getCachedSellers() {
    final raw = _get(AppConstants.sellerBox, 'data', AppConstants.sellerCacheTTL);
    if (raw == null) return null;
    return (jsonDecode(raw as String) as List)
        .cast<Map<String, dynamic>>();
  }

  // ---------------------------------------------------------------------------
  // Profile cache
  // ---------------------------------------------------------------------------

  Future<void> cacheProfile(Map<String, dynamic> profile) =>
      _put(AppConstants.profileBox, 'data', jsonEncode(profile));

  Map<String, dynamic>? getCachedProfile() {
    final raw = _get(AppConstants.profileBox, 'data', AppConstants.profileCacheTTL);
    if (raw == null) return null;
    return jsonDecode(raw as String) as Map<String, dynamic>;
  }

  Future<void> clearProfileCache() => _delete(AppConstants.profileBox, 'data');

  // ---------------------------------------------------------------------------
  // Settings (no TTL — persisted indefinitely)
  // ---------------------------------------------------------------------------

  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box<dynamic>(AppConstants.settingsBox);
    await box.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box<dynamic>(AppConstants.settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }

  // ---------------------------------------------------------------------------
  // Nuke everything (logout)
  // ---------------------------------------------------------------------------

  Future<void> clearAll() async {
    await Future.wait([
      Hive.box<dynamic>(AppConstants.couponBox).clear(),
      Hive.box<dynamic>(AppConstants.sellerBox).clear(),
      Hive.box<dynamic>(AppConstants.profileBox).clear(),
    ]);
  }
}
