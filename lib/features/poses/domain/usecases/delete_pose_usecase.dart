import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';

class DeletePoseUseCase {
  const DeletePoseUseCase(this._repository);
  final PoseRepository _repository;

  Future<void> call(Pose pose) {
    return _repository.deletePose(pose);
  }
}
