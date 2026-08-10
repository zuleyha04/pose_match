import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/core/di/service_locator.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';

class MainShellScope extends StatelessWidget {
  const MainShellScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PoseStore>(
      create: (_) => sl<PoseStore>()..loadHomePoses(),
      child: child,
    );
  }
}
