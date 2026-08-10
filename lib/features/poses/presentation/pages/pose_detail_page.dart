import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';

class PoseDetailPage extends StatelessWidget {
  const PoseDetailPage({required this.poseId, super.key});

  final String poseId;

  @override
  Widget build(BuildContext context) {
    final pose = context.select<PoseStore, Pose?>(
      (store) => store.findPoseById(poseId),
    );

    if (pose == null) {
      return const _PoseNotFoundView();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxHeight * 0.75;

          return Column(
            children: [
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: _PosePreview(pose: pose, topPadding: 18),
              ),
              Expanded(child: _PoseActions(pose: pose)),
            ],
          );
        },
      ),
    );
  }
}

class _PosePreview extends StatelessWidget {
  const _PosePreview({required this.pose, required this.topPadding});

  final Pose pose;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _PoseImage(pose: pose),

        Positioned(
          top: topPadding + 18,
          left: 16,
          child: _TopActionButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

        Positioned(
          top: topPadding + 15,
          right: 16,
          child: _FavoriteButton(pose: pose),
        ),
      ],
    );
  }
}

class _PoseImage extends StatelessWidget {
  const _PoseImage({required this.pose});

  final Pose pose;

  @override
  Widget build(BuildContext context) {
    if (pose.source == PoseSource.user) {
      return Image.file(
        File(pose.imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const _ImageErrorState();
        },
      );
    }

    return Image.asset(
      pose.imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const _ImageErrorState();
      },
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.pose});

  final Pose pose;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<PoseStore, bool>(
      (store) => store.favoriteStatus == PoseActionStatus.loading,
    );

    return Material(
      color: const Color.fromARGB(247, 15, 15, 15).withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                context.read<PoseStore>().toggleFavorite(pose);
              },
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    pose.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: pose.isFavorite ? Colors.red : Colors.white,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}

class _PoseActions extends StatelessWidget {
  const _PoseActions({required this.pose});

  final Pose pose;

  @override
  Widget build(BuildContext context) {
    final isDeleting = context.select<PoseStore, bool>(
      (store) => store.deleteStatus == PoseActionStatus.loading,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonHeight = (constraints.maxHeight * 0.30).clamp(48.0, 54.0);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: FilledButton(
                  onPressed: () {
                    // Camera feature bağlandığında
                    // seçilen poseId buradan aktarılacak.
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppTexts.useInCamera,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              if (pose.canDelete) ...[
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: OutlinedButton(
                    onPressed: isDeleting ? null : () => _deletePose(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: 0.55),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isDeleting
                        ? SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          )
                        : Text(
                            AppTexts.delete,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePose(BuildContext context) async {
    final deleted = await context.read<PoseStore>().deletePose(pose);

    if (!context.mounted) {
      return;
    }

    if (deleted) {
      Navigator.of(context).pop();
      return;
    }

    final message = context.read<PoseStore>().deleteErrorMessage;

    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

class _ImageErrorState extends StatelessWidget {
  const _ImageErrorState();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 42,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PoseNotFoundView extends StatelessWidget {
  const _PoseNotFoundView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: const Center(child: Text(AppTexts.poseNotFound)),
    );
  }
}
