import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/core/di/service_locator.dart';
import 'package:pose_match/features/camera/presentation/stores/captured_photo_store.dart';

class CapturedPhotoPage extends StatelessWidget {
  const CapturedPhotoPage({required this.photoPath, super.key});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<CapturedPhotoStore>(),
      child: _CapturedPhotoView(photoPath: photoPath),
    );
  }
}

class _CapturedPhotoView extends StatelessWidget {
  const _CapturedPhotoView({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _CapturedPhotoTopBar(onClose: context.pop),

            Expanded(
              flex: 3,
              child: _CapturedPhotoPreview(photoPath: photoPath),
            ),

            Expanded(
              flex: 1,
              child: _CapturedPhotoActions(photoPath: photoPath),
            ),
          ],
        ),
      ),
    );
  }
}

class _CapturedPhotoTopBar extends StatelessWidget {
  const _CapturedPhotoTopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: IconButton(
          onPressed: onClose,
          tooltip: AppTexts.backToCamera,
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class _CapturedPhotoPreview extends StatelessWidget {
  const _CapturedPhotoPreview({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.file(
        File(photoPath),
        fit: BoxFit.contain,
        gaplessPlayback: true,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                  size: 42,
                ),
                SizedBox(height: 12),
                Text(
                  AppTexts.photoCouldNotBeDisplayed,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CapturedPhotoActions extends StatelessWidget {
  const _CapturedPhotoActions({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final CapturedPhotoStore store = context.watch<CapturedPhotoStore>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: store.isSaving || store.isSuccess
                  ? null
                  : () => store.save(photoPath),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.primary.withValues(
                  alpha: 0.78,
                ),
                disabledForegroundColor: colorScheme.onPrimary,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildButtonContent(store, colorScheme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(
    CapturedPhotoStore store,
    ColorScheme colorScheme,
  ) {
    switch (store.status) {
      case SavePhotoStatus.initial:
        return const Row(
          key: ValueKey('initial'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded),
            SizedBox(width: 8),
            Text(AppTexts.savePhoto),
          ],
        );

      case SavePhotoStatus.saving:
        return SizedBox(
          key: const ValueKey('saving'),
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: colorScheme.onPrimary,
          ),
        );

      case SavePhotoStatus.success:
        return const Row(
          key: ValueKey('success'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded),
            SizedBox(width: 8),
            Text(AppTexts.photoSavedToGallery),
          ],
        );

      case SavePhotoStatus.error:
        return const Row(
          key: ValueKey('error'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded),
            SizedBox(width: 8),
            Text(AppTexts.photoCouldNotBeSaved),
          ],
        );
    }
  }
}
