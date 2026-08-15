import 'package:pose_match/features/camera/domain/repositories/camera_repository.dart';

class SavePhotoToGalleryUseCase {
  const SavePhotoToGalleryUseCase(this._repository);
  final CameraRepository _repository;

  Future<void> call(String photoPath) {
    return _repository.savePhotoToGallery(photoPath);
  }
}
