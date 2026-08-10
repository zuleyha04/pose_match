import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';

class GetUserPosesUseCase {
  const GetUserPosesUseCase(this._repository);
  final PoseRepository _repository;

  Future<List<Pose>> call() {
    return _repository.getUserPoses();
  }
}
