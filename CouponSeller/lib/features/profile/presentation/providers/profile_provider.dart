import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/seller_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_seller_profile_usecase.dart';
import '../../domain/usecases/update_seller_profile_usecase.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  late final GetSellerProfileUsecase _getSellerProfileUsecase;
  late final UpdateSellerProfileUsecase _updateSellerProfileUsecase;

  @override
  Future<SellerProfileEntity> build() async {
    _getSellerProfileUsecase = getIt<GetSellerProfileUsecase>();
    _updateSellerProfileUsecase = getIt<UpdateSellerProfileUsecase>();
    return _fetchProfile();
  }

  Future<SellerProfileEntity> _fetchProfile() async {
    final result = await _getSellerProfileUsecase();
    return result.fold(
      (failure) => throw failure.message,
      (profile) => profile,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProfile);
  }

  /// Returns an error message on failure, null on success.
  Future<String?> updateProfile(UpdateSellerProfileParams params) async {
    final result = await _updateSellerProfileUsecase(params);
    return result.fold(
      (failure) => failure.message,
      (updated) {
        state = AsyncData(updated);
        return null;
      },
    );
  }
}
