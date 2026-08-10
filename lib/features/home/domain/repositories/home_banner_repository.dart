import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';

abstract interface class HomeBannerRepository {
  Future<List<HomeBannerEntity>> getHomeBanners();
}
