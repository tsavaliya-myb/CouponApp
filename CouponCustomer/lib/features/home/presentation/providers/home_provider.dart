// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../services/location_service.dart';
import '../../../../core/models/category_item.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../../domain/entities/banner_ad_entity.dart';
import '../../domain/usecases/get_featured_coupons_usecase.dart';
import '../../domain/usecases/get_nearby_sellers_usecase.dart';
import '../../domain/usecases/get_banner_ads_usecase.dart';
import '../../../profile/presentation/providers/profile_provider.dart';


// ─── Selected category ────────────────────────────────────────────────────────
// null means "ALL". Non-null is the selected CategoryItem.

final selectedCategoryProvider = StateProvider<CategoryItem?>((ref) => null);

// Separate category state for the Sellers screen
final selectedSellerCategoryProvider =
    StateProvider<CategoryItem?>((ref) => null);

// ─── User Location ────────────────────────────────────────────────────────────

final userLocationProvider = FutureProvider.autoDispose<Position?>((ref) async {
  return await LocationService.getUserLocation();
});

// ─── All Coupons (keepAlive, single fetch) ────────────────────────────────────

class AllCouponsNotifier extends AsyncNotifier<List<HomeCouponEntity>> {
  @override
  Future<List<HomeCouponEntity>> build() async {
    final usecase = GetIt.I<GetFeaturedCouponsUsecase>();
    final result = await usecase();
    return result.fold(
      (failure) => throw failure,
      (list) => list,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final allCouponsProvider =
    AsyncNotifierProvider<AllCouponsNotifier, List<HomeCouponEntity>>(
  AllCouponsNotifier.new,
);

// ─── Filtered coupons (client-side) ──────────────────────────────────────────

final filteredCouponsProvider =
    Provider.autoDispose<AsyncValue<List<HomeCouponEntity>>>((ref) {
  final allAsync = ref.watch(allCouponsProvider);
  final category = ref.watch(selectedCategoryProvider);

  return allAsync.whenData((all) {
    if (category == null) return all;
    return all.where((c) => c.category == category.slug).toList();
  });
});

// Keep alias for backward compat with home_screen references
final featuredCouponsProvider =
    Provider.autoDispose<AsyncValue<List<HomeCouponEntity>>>((ref) {
  final filteredAsync = ref.watch(filteredCouponsProvider);
  return filteredAsync.whenData(
      (list) => list.where((c) => c.status != 'USED').toList());
});

// ─── All Sellers (keepAlive, single fetch with high limit) ───────────────────

class AllSellersNotifier extends AsyncNotifier<List<NearbySellerEntity>> {
  @override
  Future<List<NearbySellerEntity>> build() async {
    final profile = await ref.watch(profileProvider.future);
    final cityId = profile.cityId;
    if (cityId == null) return [];
    final usecase = GetIt.I<GetNearbySellersUsecase>();
    final result = await usecase(cityId: cityId);
    return result.fold(
      (failure) => throw failure,
      (list) => list,
    );
  }
}

final allSellersProvider =
    AsyncNotifierProvider<AllSellersNotifier, List<NearbySellerEntity>>(
  AllSellersNotifier.new,
);

// ─── Filtered sellers (client-side) ──────────────────────────────────────────

List<NearbySellerEntity> _filterAndMapDistance(List<NearbySellerEntity> all,
    CategoryItem? category, AsyncValue<Position?> locationAsync) {
  var filtered = all;
  if (category != null) {
    filtered = filtered.where((s) => s.category == category.slug).toList();
  }

  if (locationAsync is AsyncData && locationAsync.value != null) {
    final pos = locationAsync.value!;
    filtered = filtered.map((seller) {
      final distanceMeters = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        seller.lat,
        seller.lng,
      );
      return seller.copyWith(distanceKm: distanceMeters / 1000);
    }).toList();
  }

  return filtered;
}

final filteredSellersProvider =
    Provider.autoDispose<AsyncValue<List<NearbySellerEntity>>>((ref) {
  final allAsync = ref.watch(allSellersProvider);
  final category = ref.watch(selectedSellerCategoryProvider);
  final locationAsync = ref.watch(userLocationProvider);

  return allAsync
      .whenData((all) => _filterAndMapDistance(all, category, locationAsync));
});

final homeFilteredSellersProvider =
    Provider.autoDispose<AsyncValue<List<NearbySellerEntity>>>((ref) {
  final allAsync = ref.watch(allSellersProvider);
  final category = ref.watch(selectedCategoryProvider);
  final locationAsync = ref.watch(userLocationProvider);

  return allAsync
      .whenData((all) => _filterAndMapDistance(all, category, locationAsync));
});

// ─── Banner Ads (auto-dispose, fetched once per session) ─────────────────────

final bannerAdsProvider =
    FutureProvider.autoDispose<List<BannerAdEntity>>((ref) async {
  final profile = await ref.watch(profileProvider.future);
  final cityId = profile.cityId;
  final usecase = GetIt.I<GetBannerAdsUsecase>();
  final result = await usecase(cityId: cityId);
  return result.fold(
    (failure) => <BannerAdEntity>[], // fail silently — slider shows nothing
    (ads) => ads,
  );
});
