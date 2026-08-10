import 'package:flutter/material.dart';
import 'package:pose_match/app/router/app_router.dart';
import 'package:pose_match/app/theme/app_theme.dart';
import 'package:pose_match/core/constants/app_texts.dart';

class PoseMatchApp extends StatelessWidget {
  const PoseMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppTexts.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
