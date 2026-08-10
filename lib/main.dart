import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pose_match/app/app.dart';
import 'package:pose_match/core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupServiceLocator();

  runApp(const PoseMatchApp());
}
