import 'package:flutter/services.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/features/home/data/models/home_banner_model.dart';
import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';

class HomeBannerLocalDataSource {
  const HomeBannerLocalDataSource();

  Future<List<HomeBannerModel>> getHomeBanners() async {
    const banners = [
      HomeBannerModel(
        id: 'home_banner_1',
        imageSource: AppConstants.banner1Path,
        type: HomeBannerType.content,
      ),
      HomeBannerModel(
        id: 'home_banner_2',
        imageSource: AppConstants.banner2Path,
        type: HomeBannerType.content,
      ),
      HomeBannerModel(
        id: 'home_banner_3',
        imageSource: AppConstants.banner3Path,
        type: HomeBannerType.content,
      ),
    ];

    await Future.wait(
      banners.map((banner) => rootBundle.load(banner.imageSource)),
    );

    return banners;
  }
}
