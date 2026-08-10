import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';
import 'package:pose_match/features/home/domain/repositories/home_banner_repository.dart';

class GetHomeBannersUseCase {
  const GetHomeBannersUseCase(this._repository);
  final HomeBannerRepository _repository;

  Future<List<HomeBannerEntity>> call() {
    return _repository.getHomeBanners();
  }
}
