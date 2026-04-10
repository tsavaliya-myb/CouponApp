import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/seller_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, SellerProfileEntity>> getSellerProfile();
  Future<Either<Failure, SellerProfileEntity>> updateSellerProfile(
    UpdateSellerProfileParams params,
  );
  Future<Either<Failure, void>> uploadSellerLogo(String imagePath);
  Future<Either<Failure, void>> uploadSellerMedia({
    String? photo1Path,
    String? photo2Path,
    String? videoPath,
  });
}

class UpdateSellerProfileParams {
  final String? upiId;
  final double? latitude;
  final double? longitude;

  const UpdateSellerProfileParams({
    this.upiId,
    this.latitude,
    this.longitude,
  });
}
