enum PoseSource { recommended, user }

class Pose {
  const Pose({
    required this.id,
    required this.imagePath,
    required this.source,
    this.isFavorite = false,
  });

  final String id;
  final String imagePath;
  final PoseSource source;
  final bool isFavorite;

  bool get canDelete => source == PoseSource.user;

  Pose copyWith({
    String? id,
    String? imagePath,
    PoseSource? source,
    bool? isFavorite,
  }) {
    return Pose(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      source: source ?? this.source,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
