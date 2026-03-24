// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../../domain/usecases/get_featured_coupons_usecase.dart';
import '../../domain/usecases/get_nearby_sellers_usecase.dart';

// ─── Selected category ───────────────────────────────────────────────────────
// 'ALL' means no filter. API enums: FOOD, SALON, THEATER, SPA, CAFE, OTHER

final selectedCategoryProvider = StateProvider<String>((ref) => 'ALL');

// ─── All Coupons (single fetch) ────────────────────────────────────────────────
// Fetched ONCE. Category filtering is done client-side via filteredCouponsProvider.

class AllCouponsNotifier
    extends AutoDisposeAsyncNotifier<List<HomeCouponEntity>> {
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
    AutoDisposeAsyncNotifierProvider<AllCouponsNotifier, List<HomeCouponEntity>>(
  AllCouponsNotifier.new,
);

// ─── Filtered coupons (client-side, no extra request) ────────────────────────

final filteredCouponsProvider =
    Provider.autoDispose<AsyncValue<List<HomeCouponEntity>>>((ref) {
  final allAsync = ref.watch(allCouponsProvider);
  final category = ref.watch(selectedCategoryProvider);

  return allAsync.whenData((all) {
    if (category == 'ALL') return all;
    return all.where((c) => c.category == category).toList();
  });
});

// Keep alias for backward compat with home_screen references
final featuredCouponsProvider = filteredCouponsProvider;

// ─── Nearby Sellers (paginated) ───────────────────────────────────────────────

class NearbySellersNotifier
    extends AutoDisposeAsyncNotifier<List<NearbySellerEntity>> {
  int _page = 1;
  bool _hasMore = true;
  final List<NearbySellerEntity> _sellers = [];

  @override
  Future<List<NearbySellerEntity>> build() async {
    _page = 1;
    _hasMore = true;
    _sellers.clear();
    return _fetch();
  }

  Future<List<NearbySellerEntity>> _fetch() async {
    final usecase = GetIt.I<GetNearbySellersUsecase>();
    final category = ref.read(selectedCategoryProvider);
    // TODO: Get actual areaId from user profile provider once implemented
    const userAreaId = 'a331158a-24ed-47fc-8e3e-fa84e78cc4c4';
    
    final result = await usecase(
      areaId: userAreaId,
      categoryType: category,
      page: _page,
    );
    return result.fold(
      (failure) => throw failure,
      (list) {
        _sellers.addAll(list);
        _hasMore = list.length == 20;
        return List.unmodifiable(_sellers);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    _page++;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }
}

final nearbySellersProvider =
    AutoDisposeAsyncNotifierProvider<NearbySellersNotifier,
        List<NearbySellerEntity>>(NearbySellersNotifier.new);
