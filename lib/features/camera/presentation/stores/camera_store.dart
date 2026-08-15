import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/features/camera/data/models/camera_overlay_data.dart';
import 'package:pose_match/features/camera/domain/entities/device_camera.dart';
import 'package:pose_match/features/camera/domain/usecases/get_available_cameras_usecase.dart';

enum CameraStatus { initial, initializing, ready, switching, capturing, error }

class CameraStore extends ChangeNotifier {
  CameraStore(this._getAvailableCamerasUseCase);

  final GetAvailableCamerasUseCase _getAvailableCamerasUseCase;

  CameraController? _controller;

  CameraStatus _status = CameraStatus.initial;
  String? _errorMessage;

  List<DeviceCamera> _deviceCameras = [];

  int _sessionId = 0;
  Future<void>? _disposeFuture;

  CameraController? get controller => _controller;

  CameraStatus get status => _status;
  bool _permissionDenied = false;

  bool get permissionDenied => _permissionDenied;
  XFile? _capturedPhoto;

  XFile? get capturedPhoto => _capturedPhoto;

  bool get isCapturing => _status == CameraStatus.capturing;

  String? get errorMessage => _errorMessage;
  final ImagePicker _imagePicker = ImagePicker();

  CameraOverlayData? _overlay;
  double _overlayOpacity = 0.5;
  bool _isOverlayLoading = false;

  CameraOverlayData? get overlay => _overlay;

  double get overlayOpacity => _overlayOpacity;

  bool get hasOverlay => _overlay != null;

  bool get isOverlayLoading => _isOverlayLoading;

  bool get isReady =>
      _status == CameraStatus.ready && _controller?.value.isInitialized == true;

  Future<void> initialize() async {
    if (_status == CameraStatus.initializing || isReady) {
      return;
    }
    _permissionDenied = false;

    final int sessionId = ++_sessionId;

    _status = CameraStatus.initializing;
    _errorMessage = null;
    notifyListeners();

    try {
      // Önce varsa eski controller'ın tamamen kapanmasını bekle.
      await _disposeFuture;

      if (!_isSessionValid(sessionId)) {
        return;
      }

      _deviceCameras = await _getAvailableCamerasUseCase();

      if (!_isSessionValid(sessionId)) {
        return;
      }

      if (_deviceCameras.isEmpty) {
        _setError('Bu cihazda kullanılabilir kamera bulunamadı.', sessionId);
        return;
      }

      final DeviceCamera selectedCamera = _findPreferredCamera();

      final CameraDescription description = _toCameraDescription(
        selectedCamera,
      );

      await _initializeController(description, sessionId);
    } on CameraException catch (exception) {
      if (_isSessionValid(sessionId)) {
        _handleCameraException(exception, sessionId);
      }
    } catch (_) {
      if (_isSessionValid(sessionId)) {
        _setError('Kamera başlatılırken bir hata oluştu.', sessionId);
      }
    }
  }

  Future<void> switchCamera() async {
    if (!isReady || _status == CameraStatus.switching) {
      return;
    }

    final CameraController currentController = _controller!;

    final DeviceCameraLensDirection targetDirection =
        currentController.description.lensDirection == CameraLensDirection.back
        ? DeviceCameraLensDirection.front
        : DeviceCameraLensDirection.back;

    final DeviceCamera? targetCamera = _findCamera(targetDirection);

    if (targetCamera == null) {
      return;
    }

    final int sessionId = ++_sessionId;

    _status = CameraStatus.switching;
    _errorMessage = null;
    notifyListeners();

    await _disposeCurrentController();

    if (!_isSessionValid(sessionId)) {
      return;
    }

    await _initializeController(_toCameraDescription(targetCamera), sessionId);
  }

  Future<void> disposeCamera() async {
    ++_sessionId;
    await _disposeCurrentController();

    _status = CameraStatus.initial;
    _errorMessage = null;

    notifyListeners();
  }

  DeviceCamera _findPreferredCamera() {
    return _findCamera(DeviceCameraLensDirection.back) ?? _deviceCameras.first;
  }

  DeviceCamera? _findCamera(DeviceCameraLensDirection direction) {
    for (final DeviceCamera camera in _deviceCameras) {
      if (camera.lensDirection == direction) {
        return camera;
      }
    }

    return null;
  }

  CameraDescription _toCameraDescription(DeviceCamera camera) {
    return CameraDescription(
      name: camera.name,
      lensDirection: _mapLensDirection(camera.lensDirection),
      sensorOrientation: camera.sensorOrientation,
    );
  }

  CameraLensDirection _mapLensDirection(DeviceCameraLensDirection direction) {
    switch (direction) {
      case DeviceCameraLensDirection.front:
        return CameraLensDirection.front;

      case DeviceCameraLensDirection.back:
        return CameraLensDirection.back;

      case DeviceCameraLensDirection.external:
        return CameraLensDirection.external;
    }
  }

  Future<void> _initializeController(
    CameraDescription description,
    int sessionId,
  ) async {
    final CameraController controller = CameraController(
      description,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _controller = controller;

    debugPrint('CAMERA: controller created');

    try {
      await controller.initialize();

      debugPrint('CAMERA: initialized = ${controller.value.isInitialized}');

      debugPrint('CAMERA: previewSize = ${controller.value.previewSize}');

      if (!_isSessionValid(sessionId) || _controller != controller) {
        await controller.dispose();
        return;
      }

      _status = CameraStatus.ready;
      _errorMessage = null;

      notifyListeners();
    } on CameraException catch (exception) {
      debugPrint('CAMERA ERROR: ${exception.code} - ${exception.description}');

      if (_controller == controller) {
        _controller = null;
      }

      await controller.dispose();

      if (_isSessionValid(sessionId)) {
        _handleCameraException(exception, sessionId);
      }
    } catch (error, stackTrace) {
      debugPrint('CAMERA UNKNOWN ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (_controller == controller) {
        _controller = null;
      }

      await controller.dispose();

      if (_isSessionValid(sessionId)) {
        _setError(AppTexts.cameraInitializationError, sessionId);
      }
    }
  }

  Future<void> _disposeCurrentController() async {
    final CameraController? controller = _controller;

    _controller = null;

    if (controller == null) {
      return;
    }

    final Future<void> disposeFuture = controller.dispose();

    _disposeFuture = disposeFuture;

    try {
      await disposeFuture;
    } finally {
      if (_disposeFuture == disposeFuture) {
        _disposeFuture = null;
      }
    }
  }

  bool _isSessionValid(int sessionId) {
    return sessionId == _sessionId;
  }

  void _handleCameraException(CameraException exception, int sessionId) {
    switch (exception.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
        if (!_isSessionValid(sessionId)) {
          return;
        }

        _permissionDenied = true;
        _status = CameraStatus.error;
        _errorMessage = 'Kamera izni reddedildi.';
        notifyListeners();
        break;

      case 'CameraAccessRestricted':
        _setError('Bu cihazda kamera erişimi kısıtlanmış.', sessionId);
        break;

      default:
        _setError('Kamera başlatılamadı. Lütfen tekrar deneyin.', sessionId);
    }
  }

  void _setError(String message, int sessionId) {
    if (!_isSessionValid(sessionId)) {
      return;
    }

    _status = CameraStatus.error;
    _errorMessage = message;

    notifyListeners();
  }

  @override
  void dispose() {
    ++_sessionId;

    final CameraController? controller = _controller;
    _controller = null;

    controller?.dispose();

    super.dispose();
  }

  Future<void> pickOverlayImage() async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) {
        return;
      }

      _overlay = CameraOverlayData(
        imagePath: pickedImage.path,
        source: CameraOverlaySource.file,
      );

      _overlayOpacity = 0.5;
      _isOverlayLoading = false;

      notifyListeners();
    } catch (_) {
      // Daha sonra error state'e bağlarız.
    }
  }

  void setOverlayOpacity(double value) {
    final double newValue = value.clamp(0.0, 1.0);

    if (_overlayOpacity == newValue) {
      return;
    }

    _overlayOpacity = newValue;
    notifyListeners();
  }

  void removeOverlay() {
    if (_overlay == null) {
      return;
    }

    _overlay = null;
    _overlayOpacity = 0.5;
    _isOverlayLoading = false;

    notifyListeners();
  }

  Future<XFile?> capturePhoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _status == CameraStatus.capturing) {
      return null;
    }

    try {
      _status = CameraStatus.capturing;
      notifyListeners();

      final photo = await controller.takePicture();

      _capturedPhoto = photo;
      _status = CameraStatus.ready;
      notifyListeners();

      return photo;
    } on CameraException {
      _status = CameraStatus.ready;
      notifyListeners();

      return null;
    } catch (_) {
      _status = CameraStatus.ready;
      notifyListeners();

      return null;
    }
  }

  Future<void> pausePreview() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isPreviewPaused) {
      return;
    }

    try {
      await controller.pausePreview();
    } on CameraException {
      // Preview durdurulamazsa çekim akışını bozma.
    }
  }

  Future<void> resumePreview() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        !controller.value.isPreviewPaused) {
      return;
    }

    try {
      await controller.resumePreview();
    } on CameraException {
      // Gerekirse daha sonra error state'e bağlarız.
    }
  }

  void setInitialOverlay(CameraOverlayData overlay) {
    _overlay = overlay;
    _overlayOpacity = 0.5;
    _isOverlayLoading = false;

    notifyListeners();
  }
}
