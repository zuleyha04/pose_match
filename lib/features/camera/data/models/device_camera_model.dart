import 'package:camera/camera.dart';
import 'package:pose_match/features/camera/domain/entities/device_camera.dart';

class DeviceCameraModel extends DeviceCamera {
  const DeviceCameraModel({
    required super.id,
    required super.name,
    required super.lensDirection,
    required super.sensorOrientation,
  });

  factory DeviceCameraModel.fromCameraDescription(CameraDescription camera) {
    return DeviceCameraModel(
      id: camera.name,
      name: camera.name,
      lensDirection: _mapLensDirection(camera.lensDirection),
      sensorOrientation: camera.sensorOrientation,
    );
  }

  static DeviceCameraLensDirection _mapLensDirection(
    CameraLensDirection direction,
  ) {
    switch (direction) {
      case CameraLensDirection.front:
        return DeviceCameraLensDirection.front;

      case CameraLensDirection.back:
        return DeviceCameraLensDirection.back;

      case CameraLensDirection.external:
        return DeviceCameraLensDirection.external;
    }
  }
}
