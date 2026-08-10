import 'package:pose_match/features/poses/domain/entities/pose.dart';

abstract interface class PoseRepository {
  Future<List<Pose>> getRecommendedPoses();
  Future<List<Pose>> getUserPoses();
  Future<Pose?> addUserPose();
  Future<Pose> toggleFavorite(Pose pose);
  Future<void> deletePose(Pose pose);
}
