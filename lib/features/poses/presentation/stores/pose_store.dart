import 'package:flutter/foundation.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/usecases/add_user_pose_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/delete_pose_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/get_recommended_poses_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/get_user_poses_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/toggle_pose_favorite_usecase.dart';

enum PoseLoadStatus { initial, loading, success, error }

enum PoseActionStatus { initial, loading, success, error }

enum AddPoseStatus { initial, loading, success, error }

class PoseStore extends ChangeNotifier {
  PoseStore(
    this._getRecommendedPosesUseCase,
    this._getUserPosesUseCase,
    this._addUserPoseUseCase,
    this._togglePoseFavoriteUseCase,
    this._deletePoseUseCase,
  );

  final GetRecommendedPosesUseCase _getRecommendedPosesUseCase;
  final GetUserPosesUseCase _getUserPosesUseCase;
  final AddUserPoseUseCase _addUserPoseUseCase;
  final TogglePoseFavoriteUseCase _togglePoseFavoriteUseCase;
  final DeletePoseUseCase _deletePoseUseCase;

  PoseLoadStatus _recommendedStatus = PoseLoadStatus.initial;
  PoseLoadStatus _userPosesStatus = PoseLoadStatus.initial;
  AddPoseStatus _addPoseStatus = AddPoseStatus.initial;
  PoseActionStatus _favoriteStatus = PoseActionStatus.initial;
  PoseActionStatus _deleteStatus = PoseActionStatus.initial;

  List<Pose> _recommendedPoses = [];
  List<Pose> _userPoses = [];

  String? _recommendedErrorMessage;
  String? _userPosesErrorMessage;
  String? _addPoseErrorMessage;
  String? _favoriteErrorMessage;
  String? _deleteErrorMessage;

  PoseLoadStatus get recommendedStatus => _recommendedStatus;
  PoseLoadStatus get userPosesStatus => _userPosesStatus;
  AddPoseStatus get addPoseStatus => _addPoseStatus;
  List<Pose> get recommendedPoses => List.unmodifiable(_recommendedPoses);
  List<Pose> get userPoses => List.unmodifiable(_userPoses);
  String? get recommendedErrorMessage => _recommendedErrorMessage;
  String? get userPosesErrorMessage => _userPosesErrorMessage;
  String? get addPoseErrorMessage => _addPoseErrorMessage;
  PoseActionStatus get favoriteStatus => _favoriteStatus;
  PoseActionStatus get deleteStatus => _deleteStatus;
  String? get favoriteErrorMessage => _favoriteErrorMessage;
  String? get deleteErrorMessage => _deleteErrorMessage;

  Future<void> loadRecommendedPoses() async {
    _recommendedStatus = PoseLoadStatus.loading;
    _recommendedErrorMessage = null;

    notifyListeners();

    try {
      _recommendedPoses = await _getRecommendedPosesUseCase();

      _recommendedStatus = PoseLoadStatus.success;
    } catch (error, stackTrace) {
      debugPrint('ÖNERİLEN POZLAR YÜKLEME HATASI: $error');
      debugPrintStack(stackTrace: stackTrace);

      _recommendedStatus = PoseLoadStatus.error;
      _recommendedErrorMessage = 'Önerilen pozlar yüklenirken bir hata oluştu.';
    }

    notifyListeners();
  }

  Future<void> loadUserPoses() async {
    _userPosesStatus = PoseLoadStatus.loading;
    _userPosesErrorMessage = null;

    notifyListeners();

    try {
      _userPoses = await _getUserPosesUseCase();

      _userPosesStatus = PoseLoadStatus.success;
    } catch (error, stackTrace) {
      debugPrint('KULLANICI POZLARI YÜKLEME HATASI: $error');
      debugPrintStack(stackTrace: stackTrace);

      _userPosesStatus = PoseLoadStatus.error;
      _userPosesErrorMessage = 'Pozların yüklenirken bir hata oluştu.';
    }

    notifyListeners();
  }

  Future<void> loadHomePoses() async {
    await Future.wait([loadRecommendedPoses(), loadUserPoses()]);
  }

  Future<bool> addUserPose() async {
    _addPoseStatus = AddPoseStatus.loading;
    _addPoseErrorMessage = null;

    notifyListeners();

    try {
      debugPrint('1 - PoseStore.addUserPose başladı.');

      final pose = await _addUserPoseUseCase();

      debugPrint('2 - AddUserPoseUseCase tamamlandı. Pose: $pose');

      if (pose == null) {
        debugPrint('3 - Kullanıcı galeriden fotoğraf seçmeden çıktı.');

        _addPoseStatus = AddPoseStatus.initial;

        notifyListeners();

        return false;
      }

      _userPoses = [..._userPoses, pose];

      _userPosesStatus = PoseLoadStatus.success;
      _addPoseStatus = AddPoseStatus.success;

      notifyListeners();

      debugPrint('3 - Poz başarıyla kullanıcı listesine eklendi.');

      return true;
    } catch (error, stackTrace) {
      debugPrint('POZ EKLEME HATASI: $error');

      debugPrintStack(stackTrace: stackTrace);

      _addPoseStatus = AddPoseStatus.error;
      _addPoseErrorMessage = 'Poz eklenirken bir hata oluştu.';

      notifyListeners();

      return false;
    }
  }

  Pose? findPoseById(String id) {
    for (final pose in _userPoses) {
      if (pose.id == id) {
        return pose;
      }
    }

    for (final pose in _recommendedPoses) {
      if (pose.id == id) {
        return pose;
      }
    }

    return null;
  }

  Future<void> toggleFavorite(Pose pose) async {
    _favoriteStatus = PoseActionStatus.loading;
    _favoriteErrorMessage = null;
    notifyListeners();

    try {
      final updatedPose = await _togglePoseFavoriteUseCase(pose);

      _userPoses = _userPoses.map((item) {
        return item.id == updatedPose.id ? updatedPose : item;
      }).toList();

      _recommendedPoses = _recommendedPoses.map((item) {
        return item.id == updatedPose.id ? updatedPose : item;
      }).toList();

      _favoriteStatus = PoseActionStatus.success;
    } catch (_) {
      _favoriteStatus = PoseActionStatus.error;
      _favoriteErrorMessage = 'Favori durumu güncellenemedi.';
    }

    notifyListeners();
  }

  Future<bool> deletePose(Pose pose) async {
    if (!pose.canDelete) {
      return false;
    }

    _deleteStatus = PoseActionStatus.loading;
    _deleteErrorMessage = null;
    notifyListeners();

    try {
      await _deletePoseUseCase(pose);

      _userPoses.removeWhere((item) => item.id == pose.id);

      _deleteStatus = PoseActionStatus.success;
      notifyListeners();

      return true;
    } catch (_) {
      _deleteStatus = PoseActionStatus.error;
      _deleteErrorMessage = 'Poz silinirken bir hata oluştu.';

      notifyListeners();

      return false;
    }
  }
}
