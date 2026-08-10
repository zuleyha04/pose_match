import 'package:pose_match/features/poses/data/datasources/pose_image_picker_data_source.dart';
import 'package:pose_match/features/poses/data/datasources/pose_local_data_source.dart';
import 'package:pose_match/features/poses/data/models/pose_model.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';

class PoseRepositoryImpl implements PoseRepository {
  const PoseRepositoryImpl(this._localDataSource, this._imagePickerDataSource);

  final PoseLocalDataSource _localDataSource;
  final PoseImagePickerDataSource _imagePickerDataSource;

  @override
  Future<List<Pose>> getRecommendedPoses() {
    return _localDataSource.getRecommendedPoses();
  }

  @override
  Future<List<Pose>> getUserPoses() {
    return _localDataSource.getUserPoses();
  }

  @override
  Future<Pose?> addUserPose() async {
    final imagePath = await _imagePickerDataSource.pickImageFromGallery();

    if (imagePath == null) {
      return null;
    }

    final pose = PoseModel(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      imagePath: imagePath,
      source: PoseSource.user,
    );

    await _localDataSource.addUserPose(pose);

    return pose;
  }

  @override
  Future<Pose> toggleFavorite(Pose pose) async {
    final updatedPose = PoseModel(
      id: pose.id,
      imagePath: pose.imagePath,
      source: pose.source,
      isFavorite: !pose.isFavorite,
    );

    if (pose.source == PoseSource.user) {
      await _localDataSource.updateUserPose(updatedPose);
    }

    return updatedPose;
  }

  @override
  Future<void> deletePose(Pose pose) async {
    if (!pose.canDelete) {
      return;
    }

    await _localDataSource.deleteUserPose(pose.id);
  }
}
