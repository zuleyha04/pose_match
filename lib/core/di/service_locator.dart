import 'package:get_it/get_it.dart';
import 'package:pose_match/features/camera/data/datasources/camera_local_data_source.dart';
import 'package:pose_match/features/camera/data/repositories/camera_repository_impl.dart';
import 'package:pose_match/features/camera/domain/repositories/camera_repository.dart';
import 'package:pose_match/features/camera/domain/usecases/get_available_cameras_usecase.dart';
import 'package:pose_match/features/camera/domain/usecases/save_photo_to_gallery_usecase.dart';
import 'package:pose_match/features/camera/presentation/stores/camera_store.dart';
import 'package:pose_match/features/camera/presentation/stores/captured_photo_store.dart';
import 'package:pose_match/features/home/data/datasources/home_banner_local_data_source.dart';
import 'package:pose_match/features/home/data/repositories/home_banner_repository_impl.dart';
import 'package:pose_match/features/home/domain/repositories/home_banner_repository.dart';
import 'package:pose_match/features/home/domain/usecases/get_home_banners_usecase.dart';
import 'package:pose_match/features/home/presentation/stores/home_banner_store.dart';
import 'package:pose_match/features/poses/data/datasources/pose_image_picker_data_source.dart';
import 'package:pose_match/features/poses/data/datasources/pose_local_data_source.dart';
import 'package:pose_match/features/poses/data/repositories/pose_repository_impl.dart';
import 'package:pose_match/features/poses/domain/repositories/pose_repository.dart';
import 'package:pose_match/features/poses/domain/usecases/add_user_pose_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/delete_pose_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/get_recommended_poses_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/get_user_poses_usecase.dart';
import 'package:pose_match/features/poses/domain/usecases/toggle_pose_favorite_usecase.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  _registerCoreDependencies();
  _registerHomeDependencies();
  _registerPoseDependencies();
  _registerCameraDependencies();
}

void _registerCoreDependencies() {
  sl.registerLazySingleton<SharedPreferencesAsync>(
    () => SharedPreferencesAsync(),
  );
}

void _registerHomeDependencies() {
  // Data
  sl.registerLazySingleton<HomeBannerLocalDataSource>(
    () => HomeBannerLocalDataSource(),
  );

  sl.registerLazySingleton<HomeBannerRepository>(
    () => HomeBannerRepositoryImpl(sl<HomeBannerLocalDataSource>()),
  );

  // Domain
  sl.registerLazySingleton<GetHomeBannersUseCase>(
    () => GetHomeBannersUseCase(sl<HomeBannerRepository>()),
  );

  // Presentation
  sl.registerFactory<HomeBannerStore>(
    () => HomeBannerStore(sl<GetHomeBannersUseCase>()),
  );
}

void _registerPoseDependencies() {
  // Data
  sl.registerLazySingleton<PoseLocalDataSource>(
    () => PoseLocalDataSource(sl<SharedPreferencesAsync>()),
  );

  sl.registerLazySingleton<PoseImagePickerDataSource>(
    () => PoseImagePickerDataSource(),
  );

  sl.registerLazySingleton<PoseRepository>(
    () => PoseRepositoryImpl(
      sl<PoseLocalDataSource>(),
      sl<PoseImagePickerDataSource>(),
    ),
  );

  // Domain
  sl.registerLazySingleton<GetRecommendedPosesUseCase>(
    () => GetRecommendedPosesUseCase(sl<PoseRepository>()),
  );

  sl.registerLazySingleton<GetUserPosesUseCase>(
    () => GetUserPosesUseCase(sl<PoseRepository>()),
  );

  sl.registerLazySingleton<AddUserPoseUseCase>(
    () => AddUserPoseUseCase(sl<PoseRepository>()),
  );

  // Presentation
  sl.registerFactory<PoseStore>(
    () => PoseStore(
      sl<GetRecommendedPosesUseCase>(),
      sl<GetUserPosesUseCase>(),
      sl<AddUserPoseUseCase>(),
      sl<TogglePoseFavoriteUseCase>(),
      sl<DeletePoseUseCase>(),
    ),
  );

  sl.registerLazySingleton<TogglePoseFavoriteUseCase>(
    () => TogglePoseFavoriteUseCase(sl<PoseRepository>()),
  );

  sl.registerLazySingleton<DeletePoseUseCase>(
    () => DeletePoseUseCase(sl<PoseRepository>()),
  );
}

void _registerCameraDependencies() {
  sl.registerLazySingleton<CameraLocalDataSource>(
    () => CameraLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<CameraRepository>(
    () => CameraRepositoryImpl(sl<CameraLocalDataSource>()),
  );

  sl.registerLazySingleton<GetAvailableCamerasUseCase>(
    () => GetAvailableCamerasUseCase(sl<CameraRepository>()),
  );

  sl.registerFactory<CameraStore>(
    () => CameraStore(sl<GetAvailableCamerasUseCase>()),
  );
  sl.registerLazySingleton<SavePhotoToGalleryUseCase>(
    () => SavePhotoToGalleryUseCase(sl<CameraRepository>()),
  );

  sl.registerFactory<CapturedPhotoStore>(
    () => CapturedPhotoStore(sl<SavePhotoToGalleryUseCase>()),
  );
}
