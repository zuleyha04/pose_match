abstract final class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String home = '/home';
  static const String poses = '/poses';

  static const String favorites = '/favorites';
  static const String settings = '/settings';

  static const String poseDetail = '/pose/:poseId';
  static String poseDetailPath(String poseId) {
    return '/pose/$poseId';
  }

  static const String camera = '/camera';
  static const String cameraResult = '/camera/result';
  static const String capturedPhoto = '/camera/captured-photo';
}
