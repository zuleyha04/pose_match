enum DeviceCameraLensDirection { front, back, external }

class DeviceCamera {
  const DeviceCamera({
    required this.id,
    required this.name,
    required this.lensDirection,
    required this.sensorOrientation,
  });

  final String id;
  final String name;
  final DeviceCameraLensDirection lensDirection;
  final int sensorOrientation;
}
