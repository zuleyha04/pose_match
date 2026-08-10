import 'package:pose_match/features/home/data/datasources/home_banner_local_data_source.dart';
import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';
import 'package:pose_match/features/home/domain/repositories/home_banner_repository.dart';

class HomeBannerRepositoryImpl implements HomeBannerRepository {
  const HomeBannerRepositoryImpl(this._localDataSource);
  final HomeBannerLocalDataSource _localDataSource;

  @override
  Future<List<HomeBannerEntity>> getHomeBanners() {
    return _localDataSource.getHomeBanners();
  }
}
