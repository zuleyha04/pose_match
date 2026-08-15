import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';
import 'package:pose_match/features/poses/presentation/widgets/pose_grid.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final poseStore = context.watch<PoseStore>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        title: SvgPicture.asset(
          AppConstants.favourite,
          height: 35,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        top: false,
        child: _FavoritesContent(
          poses: poseStore.favoritePoses,
          onPoseTap: (pose) {
            context.push(
              AppRoutes.poseDetailPath(pose.id),
              extra: context.read<PoseStore>(),
            );
          },
        ),
      ),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  const _FavoritesContent({required this.poses, required this.onPoseTap});

  final List<Pose> poses;
  final ValueChanged<Pose> onPoseTap;

  @override
  Widget build(BuildContext context) {
    if (poses.isEmpty) {
      return const _EmptyFavoritesState();
    }

    return PoseGrid(poses: poses, onPoseTap: onPoseTap);
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipOval(
                child: Lottie.asset(
                  AppConstants.emptyFavoritesAnimationPath,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              AppTexts.emptyFavoritesTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              AppTexts.emptyFavoritesDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
