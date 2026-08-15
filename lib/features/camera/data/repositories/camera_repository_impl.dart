import 'package:pose_match/features/camera/data/datasources/camera_local_data_source.dart';
import 'package:pose_match/features/camera/domain/entities/device_camera.dart';
import 'package:pose_match/features/camera/domain/repositories/camera_repository.dart';

class CameraRepositoryImpl implements CameraRepository {
  const CameraRepositoryImpl(this._localDataSource);
  final CameraLocalDataSource _localDataSource;

  @override
  Future<List<DeviceCamera>> getAvailableCameras() {
    return _localDataSource.getAvailableCameras();
  }

  @override
  Future<void> savePhotoToGallery(String photoPath) {
    return _localDataSource.savePhotoToGallery(photoPath);
  }
}
