import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/features/poses/data/models/pose_model.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';

class PoseLocalDataSource {
  PoseLocalDataSource(this._preferences);
  static const String _userPosesKey = 'user_poses';
  final SharedPreferencesAsync _preferences;

  Future<List<PoseModel>> getRecommendedPoses() async {
    const poses = [
      PoseModel(
        id: 'recommended_1',
        imagePath: AppConstants.recommendedPose1Path,
        source: PoseSource.recommended,
      ),
      PoseModel(
        id: 'recommended_2',
        imagePath: AppConstants.recommendedPose2Path,
        source: PoseSource.recommended,
      ),
      PoseModel(
        id: 'recommended_3',
        imagePath: AppConstants.recommendedPose3Path,
        source: PoseSource.recommended,
      ),
    ];

    await Future.wait(poses.map((pose) => rootBundle.load(pose.imagePath)));

    return poses;
  }

  Future<List<PoseModel>> getUserPoses() async {
    final storedPoses = await _preferences.getStringList(_userPosesKey) ?? [];

    return storedPoses.map((poseJson) {
      final decoded = jsonDecode(poseJson) as Map<String, dynamic>;

      return PoseModel.fromMap(decoded);
    }).toList();
  }

  Future<void> addUserPose(PoseModel pose) async {
    final currentPoses = await getUserPoses();

    final updatedPoses = [...currentPoses, pose];

    await _saveUserPoses(updatedPoses);
  }

  Future<void> updateUserPose(PoseModel updatedPose) async {
    final currentPoses = await getUserPoses();

    final updatedPoses = currentPoses.map((pose) {
      return pose.id == updatedPose.id ? updatedPose : pose;
    }).toList();

    await _saveUserPoses(updatedPoses);
  }

  Future<void> deleteUserPose(String poseId) async {
    final currentPoses = await getUserPoses();

    final updatedPoses = currentPoses
        .where((pose) => pose.id != poseId)
        .toList();

    await _saveUserPoses(updatedPoses);
  }

  Future<void> _saveUserPoses(List<PoseModel> poses) async {
    final encodedPoses = poses.map((pose) => jsonEncode(pose.toMap())).toList();

    await _preferences.setStringList(_userPosesKey, encodedPoses);
  }
}
