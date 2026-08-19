import 'package:flutter/material.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/features/poses/domain/entities/pose.dart';
import 'package:pose_match/features/poses/presentation/widgets/pose_card.dart';

class HomePoseSection extends StatelessWidget {
  const HomePoseSection({
    super.key,
    required this.title,
    required this.poses,
    this.onPoseTap,
    this.onSeeAll,
    this.emptyTitle,
    this.emptyDescription,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final String title;
  final List<Pose> poses;
  final ValueChanged<Pose>? onPoseTap;
  final VoidCallback? onSeeAll;

  final String? emptyTitle;
  final String? emptyDescription;

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (poses.isNotEmpty && onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: Colors.transparent,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppTexts.seeAll),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, size: 18),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (isLoading)
          const _PoseLoadingState()
        else if (errorMessage != null)
          _PoseErrorState(message: errorMessage!, onRetry: onRetry)
        else if (poses.isEmpty)
          _EmptyPoseState(title: emptyTitle, description: emptyDescription)
        else
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: poses.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final pose = poses[index];

                return SizedBox(
                  width: 135,
                  child: PoseCard(
                    pose: pose,
                    onTap: () => onPoseTap?.call(pose),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _PoseLoadingState extends StatelessWidget {
  const _PoseLoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 190,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _PoseErrorState extends StatelessWidget {
  const _PoseErrorState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.onSecondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 30,
            color: Theme.of(
              context,
            ).colorScheme.errorContainer.withValues(alpha: 0.75),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(AppTexts.retry),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyPoseState extends StatelessWidget {
  const _EmptyPoseState({this.title, this.description});

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.hide_image,
            size: 30,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          if (description != null) ...[
            const SizedBox(height: 6),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
