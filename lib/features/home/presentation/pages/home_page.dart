import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/core/di/service_locator.dart';
import 'package:pose_match/features/home/presentation/stores/home_banner_store.dart';
import 'package:pose_match/features/home/presentation/widgets/add_pose_card.dart';
import 'package:pose_match/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pose_match/features/home/presentation/widgets/home_banner.dart';
import 'package:pose_match/features/home/presentation/widgets/home_pose_section.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeBannerStore>(
          create: (_) => sl<HomeBannerStore>()..loadBanners(),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final poseStore = context.watch<PoseStore>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const HomeBanner(),
            const SizedBox(height: 24),

            AddPoseCard(
              onTap: () async {
                await context.read<PoseStore>().addUserPose();
              },
            ),

            const SizedBox(height: 18),
            HomePoseSection(
              title: AppTexts.recommendedPoses,
              poses: poseStore.recommendedPoses,
              isLoading: poseStore.recommendedStatus == PoseLoadStatus.loading,
              errorMessage: poseStore.recommendedStatus == PoseLoadStatus.error
                  ? poseStore.recommendedErrorMessage
                  : null,
              onRetry: poseStore.loadRecommendedPoses,
              onPoseTap: (pose) {
                context.push(
                  AppRoutes.poseDetailPath(pose.id),
                  extra: context.read<PoseStore>(),
                );
              },
            ),

            const SizedBox(height: 28),
            HomePoseSection(
              title: AppTexts.myPoses,
              poses: poseStore.userPoses,
              isLoading: poseStore.userPosesStatus == PoseLoadStatus.loading,
              errorMessage: poseStore.userPosesStatus == PoseLoadStatus.error
                  ? poseStore.userPosesErrorMessage
                  : null,
              onRetry: poseStore.loadUserPoses,
              emptyTitle: AppTexts.emptyPosesTitle,
              emptyDescription: AppTexts.emptyPosesDescription,

              onSeeAll: () async {
                StatefulNavigationShell.of(context).goBranch(2);
              },
              onPoseTap: (pose) {
                context.push(
                  AppRoutes.poseDetailPath(pose.id),
                  extra: context.read<PoseStore>(),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
