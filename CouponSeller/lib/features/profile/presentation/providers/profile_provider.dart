import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/seller_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_seller_profile_usecase.dart';
import '../../domain/usecases/update_seller_profile_usecase.dart';
import '../../domain/usecases/upload_seller_logo_usecase.dart';
import '../../domain/usecases/upload_seller_media_usecase.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  late final GetSellerProfileUsecase _getSellerProfileUsecase;
  late final UpdateSellerProfileUsecase _updateSellerProfileUsecase;
  late final UploadSellerLogoUsecase _uploadSellerLogoUsecase;
  late final UploadSellerMediaUsecase _uploadSellerMediaUsecase;

  @override
  Future<SellerProfileEntity> build() async {
    _getSellerProfileUsecase = getIt<GetSellerProfileUsecase>();
    _updateSellerProfileUsecase = getIt<UpdateSellerProfileUsecase>();
    _uploadSellerLogoUsecase = getIt<UploadSellerLogoUsecase>();
    _uploadSellerMediaUsecase = getIt<UploadSellerMediaUsecase>();
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

  /// Uploads logo and refreshes profile. Returns error message on failure, null on success.
  Future<String?> uploadLogo(String imagePath) async {
    final result = await _uploadSellerLogoUsecase(imagePath);
    return result.fold(
      (failure) => failure.message,
      (_) async {
        await refresh();
        return null;
      },
    );
  }

  /// Uploads media and refreshes profile. Returns error message on failure, null on success.
  Future<String?> uploadMedia(UploadSellerMediaParams params) async {
    final result = await _uploadSellerMediaUsecase(params);
    return result.fold(
      (failure) => failure.message,
      (_) async {
        await refresh();
        return null;
      },
    );
  }
}
