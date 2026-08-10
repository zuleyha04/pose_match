import 'package:flutter/foundation.dart';
import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';
import 'package:pose_match/features/home/domain/usecases/get_home_banners_usecase.dart';

enum HomeBannerStatus { initial, loading, success, error }

class HomeBannerStore extends ChangeNotifier {
  HomeBannerStore(this._getHomeBannersUseCase);
  final GetHomeBannersUseCase _getHomeBannersUseCase;

  HomeBannerStatus _status = HomeBannerStatus.initial;
  List<HomeBannerEntity> _banners = [];
  String? _errorMessage;

  HomeBannerStatus get status => _status;
  List<HomeBannerEntity> get banners => List.unmodifiable(_banners);
  String? get errorMessage => _errorMessage;

  Future<void> loadBanners() async {
    _status = HomeBannerStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _banners = await _getHomeBannersUseCase();
      _status = HomeBannerStatus.success;
    } catch (_) {
      _status = HomeBannerStatus.error;
      _errorMessage = 'Bannerlar yüklenirken bir hata oluştu.';
    }

    notifyListeners();
  }
}
