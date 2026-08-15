import 'package:pose_match/features/camera/domain/entities/device_camera.dart';

abstract class CameraRepository {
  Future<List<DeviceCamera>> getAvailableCameras();
  Future<void> savePhotoToGallery(String photoPath);
}
