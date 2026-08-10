import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';

class HomeBannerModel extends HomeBannerEntity {
  const HomeBannerModel({
    required super.id,
    required super.imageSource,
    required super.type,
    super.targetUrl,
  });

  factory HomeBannerModel.fromMap(Map<String, dynamic> map) {
    return HomeBannerModel(
      id: map['id'] as String,
      imageSource: map['imageSource'] as String,
      type: HomeBannerType.values.byName(map['type'] as String),
      targetUrl: map['targetUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageSource': imageSource,
      'type': type.name,
      'targetUrl': targetUrl,
    };
  }
}
