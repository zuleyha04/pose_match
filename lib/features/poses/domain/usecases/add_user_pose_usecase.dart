import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';

class AddUserPoseUseCase {
  const AddUserPoseUseCase(this._repository);
  final PoseRepository _repository;

  Future<Pose?> call() {
    return _repository.addUserPose();
  }
}
