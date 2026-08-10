enum HomeBannerType { content, advertisement }

class HomeBannerEntity {
  const HomeBannerEntity({
    required this.id,
    required this.imageSource,
    required this.type,
    this.targetUrl,
  });

  final String id;
  final String imageSource;
  final HomeBannerType type;
  final String? targetUrl;

  bool get isAdvertisement => type == HomeBannerType.advertisement;
}
