import 'package:pose_match/features/camera/domain/entities/device_camera.dart';
import 'package:pose_match/features/camera/domain/repositories/camera_repository.dart';

class GetAvailableCamerasUseCase {
  const GetAvailableCamerasUseCase(this._repository);

  final CameraRepository _repository;

  Future<List<DeviceCamera>> call() {
    return _repository.getAvailableCameras();
  }
}
