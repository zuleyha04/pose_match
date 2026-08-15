import 'package:flutter/material.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/presentation/widgets/pose_card.dart';

class PoseGrid extends StatelessWidget {
  const PoseGrid({super.key, required this.poses, required this.onPoseTap});

  final List<Pose> poses;
  final ValueChanged<Pose> onPoseTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: poses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        final pose = poses[index];

        return PoseCard(
          key: ValueKey(pose.id),
          pose: pose,
          onTap: () => onPoseTap(pose),
        );
      },
    );
  }
}
