import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';

class GetRecommendedPosesUseCase {
  const GetRecommendedPosesUseCase(this._repository);
  final PoseRepository _repository;

  Future<List<Pose>> call() {
    return _repository.getRecommendedPoses();
  }
}
