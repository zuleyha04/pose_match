import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/features/camera/data/models/camera_overlay_data.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/core/di/service_locator.dart';
import 'package:pose_match/features/camera/presentation/stores/camera_store.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({this.initialOverlay, super.key});

  final CameraOverlayData? initialOverlay;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<CameraStore>(),
      child: _CameraView(initialOverlay: initialOverlay),
    );
  }
}

class _CameraView extends StatefulWidget {
  const _CameraView({required this.initialOverlay});

  final CameraOverlayData? initialOverlay;

  @override
  State<_CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<_CameraView> {
  CameraStore? _cameraStore;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final CameraStore cameraStore = context.read<CameraStore>();

      _cameraStore = cameraStore;

      cameraStore.addListener(_onCameraStoreChanged);

      final CameraOverlayData? overlay = widget.initialOverlay;

      if (overlay != null) {
        cameraStore.setInitialOverlay(overlay);
      }

      cameraStore.initialize();
    });
  }

  @override
  void dispose() {
    _cameraStore?.removeListener(_onCameraStoreChanged);

    _cameraStore?.disposeCamera();

    super.dispose();
  }

  void _onCameraStoreChanged() {
    final CameraStore? cameraStore = _cameraStore;

    if (cameraStore == null || !cameraStore.permissionDenied) {
      return;
    }

    if (!mounted) {
      return;
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const _CameraTopBar(),

            Expanded(
              child: Consumer<CameraStore>(
                builder: (context, cameraStore, child) {
                  return _CameraContent(cameraStore: cameraStore);
                },
              ),
            ),

            const _CameraBottomControls(),
          ],
        ),
      ),
    );
  }
}

class _CameraTopBar extends StatelessWidget {
  const _CameraTopBar();

  @override
  Widget build(BuildContext context) {
    final cameraStore = context.watch<CameraStore>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
          IconButton(
            onPressed: cameraStore.isReady ? cameraStore.switchCamera : null,
            icon: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CameraContent extends StatelessWidget {
  const _CameraContent({required this.cameraStore});

  final CameraStore cameraStore;

  @override
  Widget build(BuildContext context) {
    switch (cameraStore.status) {
      case CameraStatus.initial:
      case CameraStatus.initializing:
      case CameraStatus.switching:
        return const _CameraLoading();

      case CameraStatus.ready:
      case CameraStatus.capturing:
        final controller = cameraStore.controller;

        if (controller == null || !controller.value.isInitialized) {
          return const _CameraLoading();
        }

        return _CameraPreview(controller: controller);

      case CameraStatus.error:
        return _CameraError(
          message:
              cameraStore.errorMessage ??
              'Kamera başlatılırken bir hata oluştu.',
          onRetry: cameraStore.initialize,
        );
    }
  }
}

class _CameraLoading extends StatelessWidget {
  const _CameraLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('Tekrar Dene')),
          ],
        ),
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final CameraStore cameraStore = context.watch<CameraStore>();

    final Size? previewSize = controller.value.previewSize;

    if (previewSize == null) {
      return const _CameraLoading();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: previewSize.height,
                    height: previewSize.width,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),

            if (cameraStore.hasOverlay)
              Positioned.fill(
                child: IgnorePointer(
                  child: _CameraOverlay(
                    overlay: cameraStore.overlay!,
                    opacity: cameraStore.overlayOpacity,
                  ),
                ),
              ),

            const _OverlayPickerButton(),
          ],
        );
      },
    );
  }
}

class _OverlayPickerButton extends StatelessWidget {
  const _OverlayPickerButton();

  @override
  Widget build(BuildContext context) {
    final CameraStore cameraStore = context.read<CameraStore>();

    return Positioned(
      left: 16,
      top: 0,
      bottom: 0,
      child: Center(
        child: Material(
          color: Colors.black.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: cameraStore.pickOverlayImage,
            child: const SizedBox.square(
              dimension: 48,
              child: Icon(Icons.add_rounded, color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraBottomControls extends StatelessWidget {
  const _CameraBottomControls();

  @override
  Widget build(BuildContext context) {
    final CameraStore cameraStore = context.watch<CameraStore>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.opacity_rounded, color: Colors.white, size: 20),

              const SizedBox(width: 12),

              Expanded(
                child: Slider(
                  value: cameraStore.overlayOpacity,
                  min: 0,
                  max: 1,
                  onChanged: cameraStore.hasOverlay
                      ? cameraStore.setOverlayOpacity
                      : null,
                ),
              ),

              SizedBox(
                width: 42,
                child: Text(
                  '${(cameraStore.overlayOpacity * 100).round()}%',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const _ShutterButton(),
        ],
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton();

  @override
  Widget build(BuildContext context) {
    final cameraStore = context.watch<CameraStore>();

    return GestureDetector(
      onTap: cameraStore.isReady && !cameraStore.isCapturing
          ? () async {
              final photo = await cameraStore.capturePhoto();

              if (photo == null || !context.mounted) {
                return;
              }

              await cameraStore.pausePreview();

              if (!context.mounted) {
                return;
              }

              await context.push(AppRoutes.capturedPhoto, extra: photo.path);

              if (!context.mounted) {
                return;
              }

              await cameraStore.resumePreview();
            }
          : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: cameraStore.isCapturing ? 0.5 : 1,
        child: Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraOverlay extends StatelessWidget {
  const _CameraOverlay({required this.overlay, required this.opacity});

  final CameraOverlayData overlay;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: switch (overlay.source) {
        CameraOverlaySource.asset => Image.asset(
          overlay.imagePath,
          fit: BoxFit.contain,
        ),
        CameraOverlaySource.file => Image.file(
          File(overlay.imagePath),
          fit: BoxFit.contain,
        ),
      },
    );
  }
}
