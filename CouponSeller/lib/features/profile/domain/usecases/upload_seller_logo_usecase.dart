import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

@injectable
class UploadSellerLogoUsecase {
  final ProfileRepository repository;

  UploadSellerLogoUsecase(this.repository);

  Future<Either<Failure, void>> call(String imagePath) {
    return repository.uploadSellerLogo(imagePath);
  }
}
