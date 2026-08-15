import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import '../../domain/entities/pose.dart';

class PoseCard extends StatefulWidget {
  const PoseCard({super.key, required this.pose, this.onTap});

  final Pose pose;
  final VoidCallback? onTap;

  @override
  State<PoseCard> createState() => _PoseCardState();
}

class _PoseCardState extends State<PoseCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: _PoseImage(pose: widget.pose),
          ),
        ),
      ),
    );
  }
}

class _PoseImage extends StatelessWidget {
  const _PoseImage({required this.pose});

  final Pose pose;

  @override
  Widget build(BuildContext context) {
    switch (pose.source) {
      case PoseSource.recommended:
        return Image.asset(
          pose.imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );

      case PoseSource.user:
        return LayoutBuilder(
          builder: (context, constraints) {
            final pixelRatio = MediaQuery.devicePixelRatioOf(context);

            final cacheWidth = (constraints.maxWidth * pixelRatio).round();

            return Image.file(
              File(pose.imagePath),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              cacheWidth: cacheWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  return child;
                }

                return const _PoseImageLoading();
              },
            );
          },
        );
    }
  }
}

class _PoseImageLoading extends StatelessWidget {
  const _PoseImageLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: const Center(
        child: SizedBox.square(
          dimension: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
