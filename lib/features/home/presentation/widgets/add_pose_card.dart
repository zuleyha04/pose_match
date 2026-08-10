import 'package:flutter/material.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/core/services/haptic_service.dart';

class AddPoseCard extends StatefulWidget {
  const AddPoseCard({super.key, this.onTap, this.isLoading = false});

  final VoidCallback? onTap;
  final bool isLoading;

  @override
  State<AddPoseCard> createState() => _AddPoseCardState();
}

class _AddPoseCardState extends State<AddPoseCard> {
  bool _isPressed = false;

  Future<void> _handleTap() async {
    await HapticService.light();
    widget.onTap?.call();
  }

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
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 140));

        if (!mounted) return;

        _setPressed(false);
      },
      onTapCancel: () => _setPressed(false),
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isPressed
                ? AppColors.primary.withValues(alpha: 0.55)
                : AppColors.primary.withValues(alpha: 0.25),
            width: _isPressed ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            const _AddPoseThumbnail(),
            const SizedBox(width: 14),
            const Expanded(child: _AddPoseTexts()),
            const SizedBox(width: 8),
            widget.isLoading
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const _ChevronIcon(),
          ],
        ),
      ),
    );
  }
}

class _AddPoseThumbnail extends StatelessWidget {
  const _AddPoseThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 190, 25).withValues(alpha: 1),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.primary.withValues(alpha: 1)),
      ),
      child: const Center(
        child: Icon(Icons.add_a_photo, size: 27, color: AppColors.white),
      ),
    );
  }
}

class _AddPoseTexts extends StatelessWidget {
  const _AddPoseTexts();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppTexts.addPose,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        SizedBox(height: 5),
        Text(
          AppTexts.addPoseDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _ChevronIcon extends StatelessWidget {
  const _ChevronIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      size: 26,
      color: AppColors.primary.withValues(alpha: 1),
    );
  }
}
