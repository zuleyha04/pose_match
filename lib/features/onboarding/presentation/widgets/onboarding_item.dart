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

  static const double _imageBorderRadius = 24;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_imageBorderRadius),
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spacing16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),

          const SizedBox(height: AppSizes.spacing8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
