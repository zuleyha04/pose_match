import 'package:pose_match/features/poses/domain/entities/pose.dart';

class PoseModel extends Pose {
  const PoseModel({
    required super.id,
    required super.imagePath,
    required super.source,
    super.isFavorite,
  });

  factory PoseModel.fromMap(Map<String, dynamic> map) {
    return PoseModel(
      id: map['id'] as String,
      imagePath: map['imagePath'] as String,
      source: PoseSource.values.byName(map['source'] as String),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'source': source.name,
      'isFavorite': isFavorite,
    };
  }
}
