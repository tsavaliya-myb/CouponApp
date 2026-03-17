// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/home_coupon_entity.dart';
import '../../domain/entities/nearby_seller_entity.dart';
import '../../domain/usecases/get_featured_coupons_usecase.dart';
import '../../domain/usecases/get_nearby_sellers_usecase.dart';

// ─── Selected category ───────────────────────────────────────────────────────

final selectedCategoryProvider = StateProvider<String>((ref) => 'popular');

// ─── Featured Coupons (paginated) ─────────────────────────────────────────────

class FeaturedCouponsNotifier
    extends AutoDisposeAsyncNotifier<List<HomeCouponEntity>> {
  int _page = 1;
  bool _hasMore = true;
  final List<HomeCouponEntity> _coupons = [];

  @override
  Future<List<HomeCouponEntity>> build() async {
    _page = 1;
    _hasMore = true;
    _coupons.clear();
    final category = ref.watch(selectedCategoryProvider);
    return _fetch(category);
  }

  Future<List<HomeCouponEntity>> _fetch(String category) async {
    final usecase = GetIt.I<GetFeaturedCouponsUsecase>();
    final result = await usecase(category: category, page: _page);
    return result.fold(
      (failure) => throw failure,
      (list) {
        _coupons.addAll(list);
        _hasMore = list.length == 20;
        return List.unmodifiable(_coupons);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    _page++;
    final category = ref.read(selectedCategoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(category));
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    _coupons.clear();
    ref.invalidateSelf();
  }
}

final featuredCouponsProvider =
    AutoDisposeAsyncNotifierProvider<FeaturedCouponsNotifier,
        List<HomeCouponEntity>>(FeaturedCouponsNotifier.new);

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
    final result = await usecase(page: _page);
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
