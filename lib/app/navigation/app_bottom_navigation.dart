import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_texts.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  static const double _height = 70;
  static const double _centerButtonSpace = 84;
  static const double _notchMargin = 5;
  static const double _borderRadius = 22;
  static const double _iconSize = 28;
  static const double _cameraButtonSize = 60;

  static const List<_NavigationItem> _items = [
    _NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: AppTexts.home,
    ),
    _NavigationItem(
      icon: Icons.favorite_border_rounded,
      selectedIcon: Icons.favorite_rounded,
      label: AppTexts.favorites,
    ),
    _NavigationItem(
      icon: Icons.collections_outlined,
      selectedIcon: Icons.collections_rounded,
      label: AppTexts.myPoses,
    ),
    _NavigationItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: AppTexts.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: BottomAppBar(
            height: _height,
            color: AppColors.background,
            elevation: 15,
            shadowColor: colorScheme.shadow.withValues(alpha: 0.18),
            notchMargin: _notchMargin,
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            child: Row(
              children: [
                Expanded(
                  child: _NavigationButton(
                    item: _items[0],
                    isSelected: currentIndex == 0,
                    onTap: () => onDestinationSelected(0),
                  ),
                ),
                Expanded(
                  child: _NavigationButton(
                    item: _items[1],
                    isSelected: currentIndex == 1,
                    onTap: () => onDestinationSelected(1),
                  ),
                ),
                const SizedBox(width: _centerButtonSpace),
                Expanded(
                  child: _NavigationButton(
                    item: _items[2],
                    isSelected: currentIndex == 2,
                    onTap: () => onDestinationSelected(2),
                  ),
                ),
                Expanded(
                  child: _NavigationButton(
                    item: _items[3],
                    isSelected: currentIndex == 3,
                    onTap: () => onDestinationSelected(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppCameraButton extends StatelessWidget {
  const AppCameraButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: AppBottomNavigation._cameraButtonSize,
      child: FloatingActionButton(
        heroTag: 'camera_button',
        onPressed: () => context.push(AppRoutes.camera),
        tooltip: AppTexts.addPose,
        elevation: 10,
        highlightElevation: 5,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
        child: const Icon(Icons.photo_camera, size: 30),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color iconColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Tooltip(
        message: item.label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          containedInkWell: true,
          highlightShape: BoxShape.circle,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: _animationDuration,
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedScale(
                duration: _animationDuration,
                curve: Curves.easeOutBack,
                scale: isSelected ? 1.06 : 1,
                child: Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: AppBottomNavigation._iconSize,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
