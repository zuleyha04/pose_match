import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';

class TogglePoseFavoriteUseCase {
  const TogglePoseFavoriteUseCase(this._repository);
  final PoseRepository _repository;

  Future<Pose> call(Pose pose) {
    return _repository.toggleFavorite(pose);
  }
}
