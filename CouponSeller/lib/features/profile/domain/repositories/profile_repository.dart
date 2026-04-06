import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/seller_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, SellerProfileEntity>> getSellerProfile();
  Future<Either<Failure, SellerProfileEntity>> updateSellerProfile(
    UpdateSellerProfileParams params,
  );
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
