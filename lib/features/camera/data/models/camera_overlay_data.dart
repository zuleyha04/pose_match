enum CameraOverlaySource { asset, file }

class CameraOverlayData {
  const CameraOverlayData({required this.imagePath, required this.source});

  final String imagePath;
  final CameraOverlaySource source;
}
