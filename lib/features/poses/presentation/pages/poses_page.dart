import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/features/poses/presentation/widgets/pose_grid.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';

class PosesPage extends StatelessWidget {
  const PosesPage({super.key});

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
          AppConstants.poses,
          height: 35,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        top: false,
        child: _PosesContent(
          poses: poseStore.userPoses,
          status: poseStore.userPosesStatus,
          errorMessage: poseStore.userPosesErrorMessage,
          onRetry: poseStore.loadUserPoses,
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

class _PosesContent extends StatelessWidget {
  const _PosesContent({
    required this.poses,
    required this.status,
    required this.errorMessage,
    required this.onRetry,
    required this.onPoseTap,
  });

  final List<Pose> poses;
  final PoseLoadStatus status;
  final String? errorMessage;
  final VoidCallback onRetry;
  final ValueChanged<Pose> onPoseTap;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case PoseLoadStatus.initial:
      case PoseLoadStatus.loading:
        return const _LoadingState();

      case PoseLoadStatus.error:
        return _ErrorState(message: errorMessage, onRetry: onRetry);

      case PoseLoadStatus.success:
        if (poses.isEmpty) {
          return const _EmptyState();
        }

        return PoseGrid(poses: poses, onPoseTap: onPoseTap);
    }
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 34,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? AppTexts.poseLoadError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(AppTexts.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: ClipOval(
                child: Lottie.asset(
                  AppConstants.emptyPosesAnimationPath,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppTexts.emptyPosesTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              AppTexts.emptyPosesDescription,
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
