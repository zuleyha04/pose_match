import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_match/app/navigation/app_bottom_navigation.dart';
import 'package:pose_match/core/services/haptic_service.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({
    required this.navigationShell,
    required this.onAddPosePressed,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final VoidCallback onAddPosePressed;

  Future<void> _handleDestinationSelected(int index) async {
    if (index == navigationShell.currentIndex) {
      navigationShell.goBranch(index, initialLocation: true);
      return;
    }

    await HapticService.selection();

    navigationShell.goBranch(index);
  }

  Future<void> _handleAddPosePressed() async {
    await HapticService.medium();
    onAddPosePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: Transform.translate(
        offset: const Offset(8, 0),
        child: AppCameraButton(onPressed: _handleAddPosePressed),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _handleDestinationSelected,
      ),
    );
  }
}
