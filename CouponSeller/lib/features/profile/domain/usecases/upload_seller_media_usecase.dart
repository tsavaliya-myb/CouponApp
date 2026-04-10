import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

class UploadSellerMediaParams {
  final String? photo1Path;
  final String? photo2Path;
  final String? videoPath;

  UploadSellerMediaParams({
    this.photo1Path,
    this.photo2Path,
    this.videoPath,
  });
}

@injectable
class UploadSellerMediaUsecase {
  final ProfileRepository repository;

  UploadSellerMediaUsecase(this.repository);

  Future<Either<Failure, void>> call(UploadSellerMediaParams params) {
    return repository.uploadSellerMedia(
      photo1Path: params.photo1Path,
      photo2Path: params.photo2Path,
      videoPath: params.videoPath,
    );
  }
}
