import 'package:flutter/foundation.dart';
import 'package:pose_match/features/camera/domain/usecases/save_photo_to_gallery_usecase.dart';

enum SavePhotoStatus { initial, saving, success, error }

class CapturedPhotoStore extends ChangeNotifier {
  CapturedPhotoStore(this._savePhotoToGalleryUseCase);

  final SavePhotoToGalleryUseCase _savePhotoToGalleryUseCase;

  SavePhotoStatus _status = SavePhotoStatus.initial;
  String? _errorMessage;

  SavePhotoStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get isSaving => _status == SavePhotoStatus.saving;
  bool get isSuccess => _status == SavePhotoStatus.success;
  bool get hasError => _status == SavePhotoStatus.error;

  Future<void> save(String photoPath) async {
    if (isSaving || isSuccess) {
      return;
    }

    _status = SavePhotoStatus.saving;
    _errorMessage = null;
    notifyListeners();

    try {
      await _savePhotoToGalleryUseCase(photoPath);

      _status = SavePhotoStatus.success;
    } catch (error, stackTrace) {
      debugPrint('PHOTO SAVE ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      _status = SavePhotoStatus.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }
}
