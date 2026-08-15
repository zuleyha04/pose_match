import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pose_match/app/app.dart';
import 'package:pose_match/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupServiceLocator();

  runApp(const PoseMatchApp());
}
