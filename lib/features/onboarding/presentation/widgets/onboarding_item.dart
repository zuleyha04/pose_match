import 'package:flutter/material.dart';
import 'package:pose_match/core/constants/app_sizes.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
    super.key,
  });

  final String imagePath;
  final String title;
  final String description;

  static const double _maximumImageWidth = 320;
  static const double _maximumImageHeight = 300;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _maximumImageWidth,
              maxHeight: _maximumImageHeight,
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: _maximumImageHeight,
                  child: Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 55),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.spacing32),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
